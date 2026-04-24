// lib/feature/chat/service/chat_socket_service.dart

import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocketService {
  WebSocketChannel? channel;

  /// Render websocket URL
  /// ws:// for local
  /// wss:// for production

  void connect({
    required int roomId,
    required int userId,
  }) {
    final url =
        "wss://skills-app-service.onrender.com/ws/chat/$roomId/?user_id=$userId";

    channel = WebSocketChannel.connect(
      Uri.parse(url),
    );
  }

  Stream get stream => channel!.stream;

  void sendMessage({
    required int senderId,
    required String message,
  }) {
    final data = {
      "type": "message",
      "sender_id": senderId,
      "message": message,
    };

    channel?.sink.add(jsonEncode(data));
  }

  void sendTyping({
    required int senderId,
    required bool typing,
  }) {
    final data = {
      "type": "typing",
      "sender_id": senderId,
      "typing": typing,
    };

    channel?.sink.add(jsonEncode(data));
  }

  void markSeen({
    required int messageId,
  }) {
    final data = {
      "type": "seen",
      "message_id": messageId,
    };

    channel?.sink.add(jsonEncode(data));
  }

  void disconnect() {
    channel?.sink.close();
  }
}