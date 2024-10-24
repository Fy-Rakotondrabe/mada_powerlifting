import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lights/model/meet.dart';
import 'package:lights/model/judge.dart';
import 'package:lights/model/light.dart';
import 'package:lights/router.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServerConnection with WidgetsBindingObserver {
  final String baseUrl;
  late IOWebSocketChannel _channel;
  final void Function(Map<String, dynamic>) onUpdate;
  final void Function() onDisconnected;
  String? _judgeId;
  Judge? _currentJudge;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isConnected = true;
  bool _wasManuallyDisconnected = false;
  final GoRouter router;

  ServerConnection(
      this.baseUrl, this.onUpdate, this.onDisconnected, this.router) {
    WidgetsBinding.instance.addObserver(this);
    _initWebSocket();
    _initConnectivityListener();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App is in background or screen is locked
        _handleAppBackground();
        break;
      case AppLifecycleState.resumed:
        // App is in foreground again
        _handleAppForeground();
        break;
      default:
        break;
    }
  }

  void _handleAppBackground() {
    _wasManuallyDisconnected = true;
    removeJudge();
    _channel.sink.close();
    _isConnected = false;
  }

  void _handleAppForeground() {
    if (_wasManuallyDisconnected) {
      // Navigate back to scan screen using GoRouter
      router.go(scanRoute);
      _wasManuallyDisconnected = false;
    }
  }

  void _initWebSocket() {
    try {
      _channel = IOWebSocketChannel.connect(
        'ws://${Uri.parse(baseUrl).authority}',
      );
      _channel.stream.listen(
        (message) {
          final data = jsonDecode(message);
          if (data['type'] == 'disconnected') {
            // Server has disconnected this judge
            _handleDisconnection();
          } else {
            onUpdate(data);
          }
        },
        onDone: () {
          // WebSocket connection closed
          if (_isConnected && !_wasManuallyDisconnected) {
            // Only try to reconnect if we think we're still connected
            // and it wasn't a manual disconnection
            _reconnectWebSocket();
          }
        },
        onError: (error) {
          log('WebSocket error: $error');
          _handleDisconnection();
        },
      );
    } catch (e) {
      log('Failed to connect to WebSocket: $e');
      _handleDisconnection();
    }
  }

  void _reconnectWebSocket() {
    if (_wasManuallyDisconnected) return;

    Future.delayed(Duration(seconds: 5), () {
      if (_isConnected && !_wasManuallyDisconnected) {
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
      } else if (!_isConnected && !_wasManuallyDisconnected) {
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
      _wasManuallyDisconnected = false;
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
    if (_isConnected && !_wasManuallyDisconnected) {
      log(light.toString());
      _channel.sink.add(jsonEncode({
        'type': 'postLight',
        'light': light.toJson(),
      }));
    }
  }

  void resetLight() {
    if (_isConnected && !_wasManuallyDisconnected) {
      _channel.sink.add(jsonEncode({'type': 'resetLight'}));
    }
  }

  void removeJudge() {
    log('Removing judge');
    if (_currentJudge != null && _isConnected) {
      try {
        _channel.sink.add(jsonEncode({
          'type': 'removeJudge',
          'judge': _currentJudge!.toJson(),
        }));
      } catch (e) {
        log('Error removing judge: $e');
      }
      _judgeId = null;
      _currentJudge = null;
    }
  }

  void _handleDisconnection() {
    _isConnected = false;
    _judgeId = null;
    _currentJudge = null;
    try {
      _channel.sink.close();
    } catch (e) {
      log('Error closing channel: $e');
    }
    onDisconnected(); // Call the disconnection callback
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    removeJudge();
    try {
      _channel.sink.close();
    } catch (e) {
      log('Error disposing channel: $e');
    }
    _connectivitySubscription.cancel();
  }
}
