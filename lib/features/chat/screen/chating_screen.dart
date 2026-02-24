import 'package:flutter/material.dart';

class ChatingScreen extends StatefulWidget {
  const ChatingScreen({super.key});

  @override
  State<ChatingScreen> createState() => _ChatingScreenState();
}

class _ChatingScreenState extends State<ChatingScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Store messages
  List<Map<String, dynamic>> messages = [];

  // Sample typing simulation
  bool isTyping = false;

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({"text": text, "isMe": true, "time": TimeOfDay.now()});
      _controller.clear();
      isTyping = false;
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate reply from other user
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        messages.add({
          "text": "This is a reply to '$text'",
          "isMe": false,
          "time": TimeOfDay.now()
        });

        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 60,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Chat"),
        titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        scrolledUnderElevation: 0,
        shadowColor: Colors.white,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment:
                  msg["isMe"] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: msg["isMe"]
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(msg["isMe"] ? 12 : 0),
                        bottomRight: Radius.circular(msg["isMe"] ? 0 : 12),
                      ),
                    ),
                    child: Text(
                      msg["text"],
                      style: TextStyle(
                          color: msg["isMe"] ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),

          // Typing field
          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (v) {
                        setState(() {
                          isTyping = v.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send button
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: isTyping ? Colors.blueAccent : Colors.grey,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: isTyping
                          ? () => sendMessage(_controller.text)
                          : null,
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