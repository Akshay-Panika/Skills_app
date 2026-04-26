import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocketService {
  WebSocketChannel? chatSocket;
  WebSocketChannel? roomSocket;

  void connectChat({
    required int roomId,
    required int userId,
    required Function(Map<String, dynamic>) onEvent,
  }) {
    final url =
        "wss://skills-app-service.onrender.com/ws/chat/$roomId/?user_id=$userId";

    chatSocket = WebSocketChannel.connect(Uri.parse(url),);

    chatSocket!.stream.listen(
          (event) {
        try {
          final data = jsonDecode(event);
          onEvent(data);
        } catch (e) {
          print("Chat parse error: $e");
        }
      },
      onError: (e) {
        print("Chat socket error: $e");
      },
      onDone: () {
        print("Chat socket closed");
      },
    );
  }

  void connectRooms({
    required int userId,
    required Function(Map<String, dynamic>) onEvent,
  }) {
    final url =
        "wss://skills-app-service.onrender.com/ws/user/$userId/rooms/";

    roomSocket = WebSocketChannel.connect(
      Uri.parse(url),
    );

    roomSocket!.stream.listen(
          (event) {
        try {
          final data = jsonDecode(event);
          onEvent(data);
        } catch (e) {
          print("Room parse error: $e");
        }
      },
      onError: (e) {
        print("Room socket error: $e");
      },
      onDone: () {
        print("Room socket closed");
      },
    );
  }

  void sendMessage({
    required String message,
    required int senderId,
  }) {
    chatSocket?.sink.add(
      jsonEncode({
        "type": "chat_message",
        "message": message,
        "sender": senderId,
      }),
    );
  }

  void sendTyping({
    required bool typing,
    required int userId,
  }) {
    chatSocket?.sink.add(
      jsonEncode({
        "type": "typing",
        "typing": typing,
        "user_id": userId,
      }),
    );
  }

  void sendOnlineStatus({
    required bool isOnline,
    required int userId,
  }) {
    chatSocket?.sink.add(
      jsonEncode({
        "type": "online_status",
        "is_online": isOnline,
        "user_id": userId,
      }),
    );
  }

  void close() {
    chatSocket?.sink.close();
    roomSocket?.sink.close();
  }
}
