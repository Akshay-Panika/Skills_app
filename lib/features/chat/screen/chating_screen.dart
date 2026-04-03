import 'dart:convert';
import 'package:flutter/material.dart';
import '../service/chat_api_service.dart';
import '../service/chat_socket_service.dart';

class ChatingScreen extends StatefulWidget {
  final int chatRoomId;
  final int senderId;

  const ChatingScreen({
    super.key,
    required this.chatRoomId,
    required this.senderId,
  });

  @override
  State<ChatingScreen> createState() => _ChatingScreenState();
}

class _ChatingScreenState extends State<ChatingScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ChatSocketService socketService = ChatSocketService();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();

    loadOldMessages();   // ✅ GET
    connectSocket();     // ✅ LIVE
  }

  /// ✅ LOAD OLD MESSAGES
  void loadOldMessages() async {
    try {
      final data = await ChatApiService.getMessages(widget.chatRoomId);

      setState(() {
        messages = data.map<Map<String, dynamic>>((msg) {
          return {
            "text": msg["message"],
            "isMe": msg["sender"] == widget.senderId,
          };
        }).toList();
      });

      scrollToBottom();
    } catch (e) {
      print("❌ API error: $e");
    }
  }

  /// ✅ CONNECT SOCKET
  void connectSocket() {
    socketService.connect(widget.chatRoomId);

    socketService.stream.listen(
          (data) {
        final decoded = jsonDecode(data);

        setState(() {
          messages.add({
            "text": decoded["message"],
            "isMe": decoded["sender_id"] == widget.senderId,
          });
        });

        scrollToBottom();
      },
      onError: (e) => print("❌ Socket error: $e"),
      onDone: () => print("⚠️ Socket closed"),
    );
  }

  /// ✅ SEND MESSAGE
  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    socketService.sendMessage(text, widget.senderId);

    setState(() {
      messages.add({
        "text": text,
        "isMe": true,
      });
    });

    _controller.clear();
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    socketService.disconnect();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Chat"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          /// MESSAGE LIST
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final msg = messages[index];

                return Align(
                  alignment: msg["isMe"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    constraints: BoxConstraints(
                        maxWidth:
                        MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: msg["isMe"]
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["text"],
                      style: TextStyle(
                        color:
                        msg["isMe"] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// INPUT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type message...",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: sendMessage,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}