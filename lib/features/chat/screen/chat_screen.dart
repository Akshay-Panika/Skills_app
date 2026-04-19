import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';
import '../../../core/widget/app_card.dart';

class ChatScreen extends StatelessWidget {
  final List chatList;
  final bool isLoading;

  const ChatScreen({
    super.key,
    required this.chatList,
    this.isLoading = false,
  });

  bool isMe(chat) {
    return chat.isMe == true; // 👈 backend flag OR local check
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        leading: const BackButton(color: Colors.white),
        title: chatList.isNotEmpty
            ? _buildHeader(chatList.first)
            : const Text(
          "Chat",
          style: TextStyle(color: Colors.white),
        ),
      ),

      /// ================= BODY =================
      body: Column(
        children: [

          /// ===== CHAT LIST =====
          Expanded(
            child: isLoading
                ? const _ChatShimmer()
                : chatList.isEmpty
                ? const Center(child: Text("No messages yet"))
                : ListView.builder(
              padding: EdgeInsets.only(
                top: context.sWidth * 0.03,
                bottom: context.sHeight * 0.02,
              ),
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                final me = isMe(chat);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// ROLE
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.sWidth * 0.03,
                      ),
                      child: Text(
                        me ? "You" : "Seller",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColor.subtitle,
                        ),
                      ),
                    ),

                    /// MESSAGE
                    Align(
                      alignment: me
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: AppCard(
                        margin: EdgeInsets.symmetric(
                          horizontal: context.sWidth * 0.03,
                          vertical: context.sWidth * 0.01,
                        ),
                        padding: EdgeInsets.all(
                          context.sWidth * 0.03,
                        ),
                        color: me
                            ? AppColor.primary.withOpacity(0.10)
                            : Colors.white,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              chat.message ?? "",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColor.title,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  (chat.createdAt ?? "")
                                      .toString()
                                      .substring(11, 16),
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppColor.subtitle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.done_all,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          /// ================= INPUT =================
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(context.sWidth * 0.02),
              color: Colors.white,
              child: Row(
                children: [

                  /// INPUT
                  Expanded(
                    child: AppCard(
                      color: AppColor.surface,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.sWidth * 0.03,
                      ),
                      child: const TextField(
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "Type message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: context.sWidth * 0.02),

                  /// SEND
                  AppCard(
                    color: AppColor.primary,
                    padding: EdgeInsets.all(context.sWidth * 0.03),
                    child: const Icon(Icons.send, color: Colors.white),
                    onTap: () {},
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// ================= HEADER =================
  Widget _buildHeader(firstChat) {
    final profile = firstChat.service?.userProfile;

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: CachedNetworkImage(
            imageUrl: profile?.userImage ?? "",
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) =>
            const Icon(Icons.person, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile?.userName ?? "User",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              profile?.userBio ?? "",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        )
      ],
    );
  }
}

/// ================= SHIMMER =================
class _ChatShimmer extends StatelessWidget {
  const _ChatShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(context.sWidth * 0.03),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}