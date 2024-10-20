import 'dart:convert';
import 'dart:developer';

import 'package:admin/models/judge.dart';
import 'package:admin/models/light.dart';
import 'package:admin/providers/meet.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServerHandler {
  final ProviderContainer container;
  final Map<WebSocketChannel, String> connectedJudges = {};

  ServerHandler(this.container) {
    // Existing listener code remains the same
    container.listen<MeetState>(
      meetProvider,
      (old, next) {
        if (next.judges.length < (old?.judges.length ?? 0)) {
          final removedJudge = old?.judges
              .where((judge) => !next.judges.contains(judge))
              .firstOrNull;
          if (removedJudge != null) {
            removeJudgeAndDisconnect(removedJudge);
          }
        }

        if (next.lights.isEmpty) {
          resetLight();
        }
      },
    );
  }

  shelf.Handler get handler {
    final cascade = shelf.Cascade()
        .add(_handleGetCurrentMeet)
        .add(webSocketHandler(_handleWebSocket));

    return const shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addHandler(cascade.handler);
  }

  Future<shelf.Response> _handleGetCurrentMeet(shelf.Request request) async {
    if (request.method == 'GET' && request.url.path == 'current-meet') {
      final currentMeet = container.read(meetProvider).currentMeet;
      if (currentMeet != null) {
        return shelf.Response.ok(
          jsonEncode(currentMeet.toJson()),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        return shelf.Response.internalServerError();
      }
    }
    if (request.method == 'POST' && request.url.path == 'judge') {
      try {
        if (container.read(meetProvider).judges.length < 3) {
          final requestBody = await request.readAsString();
          final payload = jsonDecode(requestBody) as Map<String, dynamic>;
          final judge = Judge.fromJson(payload);
          container.read(meetProvider.notifier).addJudge(judge);
          _broadcastStateUpdate();
          return shelf.Response.ok(
            jsonEncode({'message': 'Judge added'}),
            headers: {'Content-Type': 'application/json'},
          );
        } else {
          return shelf.Response.ok(
            jsonEncode({'message': 'Judge limit reached'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      } catch (e) {
        log(e.toString());
        return shelf.Response.internalServerError();
      }
    }
    return shelf.Response.notFound('Not Found');
  }

  void removeJudgeAndDisconnect(Judge judge) {
    final entry = connectedJudges.entries
        .where((entry) => entry.value == judge.id)
        .firstOrNull;

    if (entry != null) {
      final webSocket = entry.key;
      connectedJudges.remove(webSocket);
      webSocket.sink.add(jsonEncode({'type': 'disconnected'}));
      webSocket.sink.close();
      _broadcastStateUpdate();
    }
  }

  void resetLight() {
    for (var entry in connectedJudges.entries) {
      final webSocket = entry.key;
      webSocket.sink.add(jsonEncode({'type': 'resetLight'}));
    }
  }

  void _handleWebSocket(WebSocketChannel webSocket) {
    // Send initial state
    _sendStateUpdate(webSocket);

    webSocket.stream.listen(
      (message) {
        final data = jsonDecode(message);
        switch (data['type']) {
          case 'identify':
            final judgeId = data['judgeId'];
            log('Judge connected: $judgeId');
            connectedJudges[webSocket] = judgeId;
            break;
          case 'postLight':
            final lights = container.read(meetProvider).lights;
            if (lights.length < 3) {
              final light = Light.fromJson(data['light']);
              container.read(meetProvider.notifier).addLight(light);
            }
            break;
          case 'removeJudge':
            final judge = data['judgeId'];
            container.read(meetProvider.notifier).removeJudge(judge);
            connectedJudges.remove(webSocket);
            break;
          default:
            webSocket.sink.add(jsonEncode({'error': 'Unknown message type'}));
        }
        // Broadcast updated state to all clients
        _broadcastStateUpdate();
      },
      onDone: () {
        // Handle WebSocket disconnection
        if (connectedJudges.containsKey(webSocket)) {
          final judge = connectedJudges[webSocket]!;
          container.read(meetProvider.notifier).removeJudge(judge);
          connectedJudges.remove(webSocket);
          log('Judge disconnected');
          _broadcastStateUpdate();
        }
      },
      onError: (error) {
        log('WebSocket error: $error');
        // Handle any cleanup if needed
      },
    );
  }

  void _sendStateUpdate(WebSocketChannel webSocket) {
    final lights = container.read(meetProvider).lights;
    webSocket.sink.add(jsonEncode({
      'type': 'state',
      'light': lights.map((light) => light.toJson()).toList(),
    }));
  }

  void _broadcastStateUpdate() {
    for (var webSocket in connectedJudges.keys) {
      _sendStateUpdate(webSocket);
    }
  }
}
