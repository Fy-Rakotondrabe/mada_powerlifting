import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lights/model/meet.dart';
import 'package:lights/model/judge.dart';
import 'package:lights/model/light.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServerConnection {
  final String baseUrl;
  late IOWebSocketChannel _channel;
  final void Function(Map<String, dynamic>) onUpdate;
  final void Function() onDisconnected;
  String? _judgeId;
  Judge? _currentJudge;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isConnected = true;

  ServerConnection(this.baseUrl, this.onUpdate, this.onDisconnected) {
    _initWebSocket();
    _initConnectivityListener();
  }

  void _initWebSocket() {
    _channel = IOWebSocketChannel.connect(
      'ws://${Uri.parse(baseUrl).authority}',
    );
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['type'] == 'disconnected') {
        // Server has disconnected this judge
        _handleDisconnection();
      } else {
        onUpdate(data);
      }
    }, onDone: () {
      // WebSocket connection closed
      if (_isConnected) {
        // Only try to reconnect if we think we're still connected
        _reconnectWebSocket();
      }
    }, onError: (error) {
      log('WebSocket error: $error');
      if (_isConnected) {
        _reconnectWebSocket();
      }
    });
  }

  void _reconnectWebSocket() {
    Future.delayed(Duration(seconds: 5), () {
      if (_isConnected) {
        _initWebSocket();
        _identifyWebSocket();
      }
    });
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        _isConnected = false;
        removeJudge();
      } else if (!_isConnected) {
        _isConnected = true;
        _reconnectWebSocket();
      }
    });
  }

  Future<Meet> getCurrentMeet() async {
    final response = await http.get(Uri.parse('$baseUrl/current-meet'));
    if (response.statusCode == 200) {
      log(response.body);
      return Meet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load meet');
    }
  }

  Future<String> addJudge(Judge judge) async {
    final response = await http.post(
      Uri.parse('$baseUrl/judge'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(judge.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      _currentJudge = judge;
      _judgeId = judge.id;
      _identifyWebSocket();
      return responseData['message'];
    } else {
      throw Exception('Failed to add judge');
    }
  }

  void _identifyWebSocket() {
    if (_judgeId != null) {
      log('Identifying with judge ID: $_judgeId');
      _channel.sink.add(jsonEncode({
        'type': 'identify',
        'judgeId': _judgeId,
      }));
    }
  }

  void postLight(Light light) {
    log(light.toString());
    _channel.sink.add(jsonEncode({
      'type': 'postLight',
      'light': light.toJson(),
    }));
  }

  void resetLight() {
    _channel.sink.add(jsonEncode({'type': 'resetLight'}));
  }

  void removeJudge() {
    log('Removing judge');
    if (_currentJudge != null) {
      _channel.sink.add(jsonEncode({
        'type': 'removeJudge',
        'judge': _currentJudge!.toJson(),
      }));
      _judgeId = null;
      _currentJudge = null;
    }
  }

  void _handleDisconnection() {
    _isConnected = false;
    _judgeId = null;
    _currentJudge = null;
    _channel.sink.close();
    onDisconnected(); // Call the disconnection callback
  }

  void dispose() {
    removeJudge();
    _channel.sink.close();
    _connectivitySubscription.cancel();
  }
}
