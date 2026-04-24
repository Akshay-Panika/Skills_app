import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocketService {
  WebSocketChannel? _channel;

  void connect({
    required int roomId,
    required int userId,
  }) {
    disconnect();

    final uri = Uri(
      scheme: "wss",
      host: "skills-app-service.onrender.com",
      path: "/ws/chat/$roomId/",
      queryParameters: {
        "user_id": "$userId",
      },
    );

    print("🔥 SOCKET CONNECT => $uri");

    _channel = WebSocketChannel.connect(uri);
  }

  void sendMessage({
    required int senderId,
    required String message,
  }) {
    _channel?.sink.add(jsonEncode({
      "type": "message",
      "sender_id": senderId,
      "message": message,
    }));
  }

  Stream get stream => _channel!.stream;

  void disconnect() {
    try {
      _channel?.sink.close();
    } catch (_) {}
    _channel = null;
  }
}