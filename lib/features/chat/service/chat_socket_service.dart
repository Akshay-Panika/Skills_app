import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocketService {
  WebSocketChannel? channel;

  void connect(int chatRoomId) {
    final url = "wss://skills-app-service.onrender.com/ws/chat/$chatRoomId/";

    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  Stream get stream => channel!.stream;

  void sendMessage(String message, int senderId) {
    channel!.sink.add(
      jsonEncode({
        "message": message,
        "sender": senderId,
      }),
    );
  }

  void disconnect() {
    channel?.sink.close();
  }
}