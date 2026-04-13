import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';
import '../controller/chat_controller.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  bool isBuyer(int buyerId) {
    return controller.userId == buyerId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,

      /// 🔥 AppBar
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 1,
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: Obx(() {
          if (controller.isLoading.value) {
            return Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.6),
              child: Row(
                children: [
                  /// Avatar shimmer
                  CircleAvatar(
                    radius: context.sHeight * 0.024,
                    backgroundColor: Colors.white,
                  ),

                  const SizedBox(width: 10),

                  /// Text shimmer
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 70,
                        color: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            );
          }

          if (controller.chatList.isEmpty) {
            return Row(
              children: [
                CircleAvatar(
                  child: FaIcon(FontAwesomeIcons.circleUser,color: AppColor.primary,),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Service Chat",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      "Buyer / Seller",
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                )
              ],
            );
          }
          final firstChat = controller.chatList.first;

          return Obx(() {
            if (controller.isLoading.value || controller.chatList.isEmpty) {
              return Row(
                children: [
                  CircleAvatar(
                    child: FaIcon(FontAwesomeIcons.circleUser, color: AppColor.primary),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Service Chat",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text("Buyer / Seller",
                          style: TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  )
                ],
              );
            }

            final firstChat = controller.chatList.first;
            final profileImage =
                firstChat.service?.userProfile?.userImage ?? "";

            return Row(
              children: [
                CircleAvatar(
                  radius: context.sHeight * 0.024,
                  backgroundColor: AppColor.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(context.sHeight * 0.036),
                    child: CachedNetworkImage(
                      imageUrl: profileImage,
                      fit: BoxFit.cover,
                      width: context.sHeight * 0.046,
                      height: context.sHeight * 0.046,

                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        alignment: Alignment.center,
                        child: FaIcon(
                          FontAwesomeIcons.image,
                          color: Colors.grey[400],
                          size: 25,
                        ),
                      ),

                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image_outlined,
                            color: Colors.grey, size: 25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstChat.service?.userProfile?.userName ?? "User",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),

                    /// 🔥 Dynamic Name
                    Text(
                      firstChat.service?.userProfile?.userBio ?? "User",
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                )
              ],
            );
          });
        }),
      ),

      body: Column(
        children: [

          /// 🔥 Chat List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ChatShimmer();
              }

              if (controller.chatList.isEmpty) {
                return const Center(child: Text("No messages yet"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: controller.chatList.length,
                itemBuilder: (context, index) {
                  final chat = controller.chatList[index];
                  final isMe = isBuyer(chat.buyer);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Role Label
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          isMe ? "You (Buyer)" : "Seller",
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColor.subtitle,
                          ),
                        ),
                      ),

                      Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,

                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 6),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                            maxWidth:
                            MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppColor.primary.withOpacity(0.15)
                                : AppColor.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(isMe ? 12 : 0),
                              bottomRight: Radius.circular(isMe ? 0 : 12),
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [

                              /// Message
                              Text(
                                chat.message,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColor.title,
                                ),
                              ),

                              const SizedBox(height: 5),

                              /// Time + Status
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    chat.createdAt.substring(11, 16),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColor.subtitle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.done_all,
                                    size: 16,
                                    color: chat.status == "accepted"
                                        ? AppColor.primary
                                        : Colors.grey,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),

          /// 🔥 MESSAGE INPUT BOX
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: const BoxDecoration(
                color: AppColor.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                  /// Emoji
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined,
                        color: AppColor.subtitle),
                    onPressed: () {},
                  ),
            
                  /// TextField
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: 3, // 🔥 max 3 lines
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: const TextStyle(color: AppColor.subtitle),
                        filled: true,
                        fillColor: AppColor.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
            
                  /// Attachment
                  IconButton(
                    icon: const Icon(Icons.attach_file,
                        color: AppColor.subtitle),
                    onPressed: () {},
                  ),
            
                  /// Send Button
                  CircleAvatar(
                    backgroundColor: AppColor.primary,
                    child: IconButton(
                      icon:
                      const Icon(Icons.send, color: AppColor.white),
                      onPressed: () {
                        Get.snackbar(
                          "Coming Soon",
                          "Send message API next 🔥",
                          backgroundColor: AppColor.primary,
                          colorText: AppColor.white,
                        );
                      },
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


class ChatShimmer extends StatelessWidget {
  const ChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 6,
      itemBuilder: (context, index) {
        final isMe = index % 2 == 0;

        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Role label shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              Align(
                alignment:
                isMe ? Alignment.centerRight : Alignment.centerLeft,

                child: Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  padding: const EdgeInsets.all(10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: Radius.circular(isMe ? 12 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 12),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      /// message lines
                      Container(
                        height: 12,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 8),

                      /// time + status
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 10,
                            width: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Container(
                            height: 10,
                            width: 15,
                            color: Colors.white,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}