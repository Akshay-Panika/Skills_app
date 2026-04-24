// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/chat_controller.dart';
// import 'chat_page_screen.dart';
//
// class RoomListScreen extends StatelessWidget {
//   RoomListScreen({super.key});
//
//   final ChatController controller = Get.put(ChatController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Messages"),
//         centerTitle: false,
//       ),
//
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.roomList.isEmpty) {
//           return const Center(child: Text("No Chats Found"));
//         }
//
//         return ListView.separated(
//           itemCount: controller.roomList.length,
//           separatorBuilder: (_, __) => const Divider(height: 1),
//           itemBuilder: (context, index) {
//             final room = controller.roomList[index];
//
//             return InkWell(
//               onTap: () {
//                 Get.to(() => ChatPageScreen(
//                   roomId: room.roomId,
//                   title: room.sellerName,
//                 ));
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 12, vertical: 10),
//
//                 child: Row(
//                   children: [
//                     // PROFILE
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: CircleAvatar(
//                         radius: 28,
//                         backgroundImage: room.sellerImage.isNotEmpty
//                             ? NetworkImage(room.sellerImage)
//                             : null,
//                         child: room.sellerImage.isEmpty
//                             ? const Icon(Icons.person)
//                             : null,
//                       ),
//                     ),
//
//                     const SizedBox(width: 12),
//
//                     // NAME + MESSAGE
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             room.sellerName,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 15,
//                             ),
//                           ),
//
//                           const SizedBox(height: 3),
//
//                           Text(
//                             room.lastMessage.isEmpty
//                                 ? "Start conversation"
//                                 : room.lastMessage,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: Colors.grey.shade700,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // RIGHT SIDE
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           room.serviceName,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         const Icon(Icons.chevron_right,
//                             color: Colors.grey),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_date_format.dart';
import '../../../core/widget/app_card.dart';
import '../../../core/widget/my_appbar.dart';
import '../../notification/screen/notification_screen.dart';
import '../controller/chat_controller.dart';
import '../widget/chat_list_shimmer.dart';
import 'chat_page_screen.dart';
import '../model/chat_room_model.dart';

class RoomListScreen extends StatefulWidget {
  RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen>
    with SingleTickerProviderStateMixin {

  final controller = Get.find<ChatController>();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<ChatRoomModel> get filteredRooms {
    if (tabController.index == 1) {
      // BUYING → user is buyer
      return controller.roomList
          .where((e) => e.buyerId == controller.currentUserId)
          .toList();
    } else if (tabController.index == 2) {
      // SELLING → user is seller
      return controller.roomList
          .where((e) => e.sellerId == controller.currentUserId)
          .toList();
    }
    return controller.roomList; // ALL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,

      appBar: myAppBar(
        title: "Chat",
        titleColor: AppColor.white,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        actions: [
          AppCard(
            color: Colors.white.withOpacity(0.15),
            borderRadius: context.sWidth*0.02,
            padding: EdgeInsets.all( context.sWidth*0.018,),
            margin: EdgeInsets.zero,
            child:  Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: context.sWidth*0.05,
            ),
            onTap: () => Get.to(() => NotificationScreen()),
          ),
          SizedBox(width: context.sWidth*0.04,)

        ],
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          labelStyle:  GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: context.text14,
          ),

          unselectedLabelStyle:GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: context.text14,
          ),
          onTap: (_) => setState(() {}),
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Buying"),
            Tab(text: "Selling"),
          ],
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return ChatListShimmer();
        }

        final rooms = filteredRooms;

        if (rooms.isEmpty) {
          return const Center(child: Text("No Chats Found"));
        }

        return ListView.separated(
          padding:  EdgeInsets.symmetric(horizontal: context.sWidth*0.03, vertical: context.sWidth*0.03),
          itemCount: rooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final room = rooms[index];

            return InkWell(
              onTap: () {
                Get.to(() => ChatPageScreen(
                  roomId: room.roomId,
                  title: room.sellerName,
                ));
              },

              child: AppCard(
                margin:  EdgeInsets.only(bottom: context.sWidth*0.02,),
                padding: EdgeInsets.all(context.sWidth*0.02, ),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(context.sWidth*0.03),
                          child: CachedNetworkImage(
                            imageUrl: room.serviceImage,
                            fit: BoxFit.cover,
                            width: context.sHeight*0.1,
                            height: context.sHeight*0.1,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[100],
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.chalkboardTeacher,
                                color: Colors.grey[400],
                                size: context.sWidth*0.06,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 25),
                            ),
                          ),
                        ),

                         SizedBox(width: context.sWidth*0.03),

                        Expanded(
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Text(
                                room.sellerName,
                                style:  GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.text14,
                                ),
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      room.lastMessage.isEmpty
                                          ? "Start conversation"
                                          : room.lastMessage,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: context.text12,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 6),

                                  Icon(
                                    Icons.done_all,
                                    size: 16,
                                    color: Colors.blue,
                                  )
                                ],
                              )


                            ],
                          ),
                        ),

                      ],
                    ),
                    Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppCard(
                          color: AppColor.primary.withOpacity(0.08),
                          padding:  EdgeInsets.symmetric(horizontal: context.sWidth*0.04, vertical: context.sWidth*0.01),
                          margin: EdgeInsets.zero,
                          child: Text(
                            room.serviceName,
                            style: GoogleFonts.poppins(
                              fontSize: context.text12,
                              color: AppColor.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(AppDateFormat.format(room.updatedAt), style: TextStyle(fontSize: 12,color: AppColor.subtitle),)
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}