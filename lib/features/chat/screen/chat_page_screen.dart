import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_size.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/widget/app_date_format.dart';
import '../controller/chat_controller.dart';
import '../model/chat_message_model.dart';
import '../service/chat_socket_service.dart';

class ChatPageScreen extends StatefulWidget {
  final int roomId;
  final String title;
  final String profile;

  const ChatPageScreen({
    super.key,
    required this.roomId,
    required this.title,
    required this.profile,
  });

  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {

  final _chatController = Get.find<ChatController>();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final ChatSocketService socket = ChatSocketService();

  bool isTyping = false;
  bool isOnline = false;
  Timer? typingTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatController.fetchMessages(widget.roomId);
      socket.connectChat(
        roomId: widget.roomId,
        userId: _chatController.currentUserId!,
        onEvent: (data) {
          final type = data["type"];

          if (type == "chat_message") {
            final msg = ChatMessageModel(
              id: data["id"] ?? 0,
              room: data["room"] ?? widget.roomId,
              sender: data["sender"] ?? 0,
              senderPhone: "",
              message: data["message"] ?? "",
              isSeen: data["is_seen"] ?? false,
              createdAt: data["created_at"] ?? DateTime.now().toString(),
            );

            final alreadyExists = _chatController.messageList.any(
                  (e) => e.id == msg.id && msg.id != 0,
            );

            if (!alreadyExists) {
              _chatController.messageList.add(msg);
              _chatController.fetchRooms();
              scrollToBottom();
            }
          }

          if (type == "typing") {
            if (data["user_id"] != _chatController.currentUserId) {
              setState(() {
                isTyping = data["is_typing"] ?? false;
              });
            }
          }

          if (type == "online_status") {
            if (data["user_id"] !=
                _chatController.currentUserId) {
              setState(() {
                isOnline =
                    data["is_online"] ?? false;
              });
            }
          }

          if (type == "seen") {
            if (data["user_id"] != _chatController.currentUserId) {
              for (int i = 0; i < _chatController.messageList.length; i++) {
                final msg = _chatController.messageList[i];

                if (msg.sender == _chatController.currentUserId) {
                  _chatController.messageList[i] = ChatMessageModel(
                    id: msg.id,
                    room: msg.room,
                    sender: msg.sender,
                    senderPhone: msg.senderPhone,
                    message: msg.message,
                    isSeen: true,
                    createdAt: msg.createdAt,
                  );
                }
              }
              _chatController.messageList.refresh();
            }
          }
        },
      );

      /// user online
      socket.sendOnlineStatus(
        isOnline: true,
        userId: _chatController.currentUserId!,
      );
      socket.chatSocket?.sink.add(jsonEncode({"type": "seen"}));
      Future.delayed(const Duration(milliseconds: 500), () {
        socket.chatSocket?.sink.add(jsonEncode({"type": "seen"}));
      });
    });
  }

  void scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 150),
          () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    typingTimer?.cancel();

    socket.sendOnlineStatus(
      isOnline: false,
      userId: _chatController.currentUserId!,
    );

    socket.close();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onTyping(String value) {
    final userId = _chatController.currentUserId!;

    if (value.trim().isNotEmpty) {
      socket.sendTyping(typing: true, userId: userId);

      typingTimer?.cancel();
      typingTimer = Timer(const Duration(seconds: 2), () {
        socket.sendTyping(typing: false, userId: userId);
      });
    } else {
      socket.sendTyping(typing: false, userId: userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,

      appBar: AppBar(
        backgroundColor: AppColor.primary,
        titleSpacing: 0,
        leading: IconButton(onPressed: () {
           Get.back();
        }, icon: Icon(Icons.arrow_back_ios, color: AppColor.white)),
        title: Row(
          spacing: context.sWidth*0.02,
          children: [
             CircleAvatar(
               backgroundImage: NetworkImage(widget.profile),
             ),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: context.text14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.white
                  ),
                ),

                Text(
                  isTyping
                      ? "typing..."
                      : isOnline
                      ? "online"
                      : "offline",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [

          Expanded(
            child: Obx(() {
              final messages =
                  _chatController.messageList;

              return ListView.builder(
                controller:
                _scrollController,
                padding: EdgeInsets.all(context.sWidth*0.02),
                itemCount: messages.length,

                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = msg.sender == _chatController.currentUserId;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,

                    child: Container(
                      margin: EdgeInsets.only(
                      bottom: context.sWidth*0.02,
                      left: isMe ? context.sWidth*0.1 : context.sWidth*0.02,
                      right: isMe ? context.sWidth*0.02 : context.sWidth*0.1
                    ),

                      padding: EdgeInsets.all(context.sWidth*0.04),

                      decoration:
                      BoxDecoration(
                        color:
                        isMe ? AppColor.white
                            : AppColor.primary.withOpacity(0.06,),

                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMe ? context.sWidth*0.04:0),
                          bottomRight: Radius.circular(isMe ? 0: context.sWidth*0.04),
                          bottomLeft: Radius.circular(context.sWidth*0.04),
                          topRight: Radius.circular(context.sWidth*0.04)
                        ),
                        border: Border.all(color: AppColor.primary.withOpacity(0.1)),
                      ),

                      child: Column(
                        crossAxisAlignment:
                        isMe
                            ? CrossAxisAlignment
                            .end
                            : CrossAxisAlignment
                            .start,

                        children: [
                          Text(
                            msg.message,
                            style:
                            GoogleFonts.poppins(
                              fontSize:
                              context.text14,
                              color:
                              AppColor
                                  .title,
                            ),
                          ),

                           SizedBox(
                            height: context.sWidth*0.02,
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppDateFormat.timeDateFormat(
                                  msg.createdAt,
                                ),
                                style: GoogleFonts.poppins(
                                  fontSize: context.text10,
                                  color: AppColor.subtitle,
                                ),
                              ),

                              if (isMe) ...[
                                SizedBox(width: 4),

                                Icon(
                                  Icons.done_all,
                                  // msg.isSeen ? Icons.done_all : Icons.done,
                                  size: 16,
                                  color: msg.isSeen ? Colors.blue : Colors.grey,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: context.sWidth*0.04,
                right: context.sWidth*0.04,
                bottom: context.sWidth*0.04
              ),
              child: Row(
                spacing: context.sWidth*0.06,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _msgBox(
                      context: context,
                      controller: _messageController,
                      onChanged: onTyping,
                      // onChanged: (value) {
                      //   socket.sendTyping(
                      //     typing: value.trim().isNotEmpty,
                      //     userId: _chatController.currentUserId!,
                      //   );
                      // },
                    ),
                  ),

                  GestureDetector(
                    // onTap: () {
                    //   final text =
                    //   _messageController.text
                    //       .trim();
                    //
                    //   if (text.isEmpty) {
                    //     return;
                    //   }
                    //   socket.sendTyping(
                    //     typing: false,
                    //     userId:
                    //     _chatController
                    //         .currentUserId!,
                    //   );
                    //   socket.sendMessage(
                    //     message: text,
                    //     senderId:
                    //     _chatController
                    //         .currentUserId!,
                    //   );
                    //
                    //   _messageController
                    //       .clear();
                    //
                    //   scrollToBottom();
                    // },
                    onTap: () {
                      final text = _messageController.text.trim();

                      if (text.isEmpty) return;

                      typingTimer?.cancel();

                      socket.sendTyping(
                        typing: false,
                        userId: _chatController.currentUserId!,
                      );

                      socket.sendMessage(
                        message: text,
                        senderId: _chatController.currentUserId!,
                      );

                      _messageController.clear();
                    },

                    child: Container(
                      padding:
                      const EdgeInsets.all(12,),
                      decoration:
                      const BoxDecoration(
                        color:
                        AppColor
                            .primary,
                        shape:
                        BoxShape.circle,
                      ),

                      child:
                      const Icon(
                        Icons.send,
                        color:
                        Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _msgBox({
  required BuildContext context,
  TextEditingController? controller,
  Function(String)? onChanged,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: AppColor.primary.withOpacity(.1),
      width: 1.2,
    ),
  );

  return TextField(
    controller: controller,
    minLines: 2,
    maxLines: 4,
    keyboardType: TextInputType.multiline,
    onChanged: onChanged,
    style: GoogleFonts.poppins(
      color: AppColor.title,
      fontSize: context.text14,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColor.white,
      hintText: "Type message...",
      alignLabelWithHint: true,
      contentPadding: const EdgeInsets.all(12),
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      hintStyle: GoogleFonts.poppins(
        color: AppColor.subtitle,
        fontSize: context.text14,
      ),
    ),
  );
}

