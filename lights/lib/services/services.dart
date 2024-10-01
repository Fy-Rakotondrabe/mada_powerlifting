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
  String? _judgeId;
  Judge? _currentJudge;

  ServerConnection(this.baseUrl, this.onUpdate) {
    _initWebSocket();
  }

  void _initWebSocket() {
    _channel = IOWebSocketChannel.connect(
      'ws://${Uri.parse(baseUrl).authority}',
    );
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      onUpdate(data);
    });
  }

  Future<Meet> getCurrentMeet() async {
    final response = await http.get(Uri.parse('$baseUrl/current-meet'));
    if (response.statusCode == 200) {
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
      _identifyWebSocket();
      return responseData['message'];
    } else {
      throw Exception('Failed to add judge');
    }
  }

  void _identifyWebSocket() {
    if (_judgeId != null) {
      _channel.sink.add(jsonEncode({
        'type': 'identify',
        'judgeId': _judgeId,
      }));
    }
  }

  void postLight(Light light) {
    _channel.sink.add(jsonEncode({
      'type': 'postLight',
      'light': light.toJson(),
    }));
  }

  void resetLight() {
    _channel.sink.add(jsonEncode({'type': 'resetLight'}));
  }

  void removeJudge() {
    if (_currentJudge != null) {
      _channel.sink.add(jsonEncode({
        'type': 'removeJudge',
        'judge': _currentJudge!.toJson(),
      }));
      _judgeId = null;
      _currentJudge = null;
    }
  }

  void dispose() {
    _channel.sink.close();
  }
}
