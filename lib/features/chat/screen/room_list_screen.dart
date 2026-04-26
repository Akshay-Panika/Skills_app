import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';
import '../../../core/widget/app_card.dart';
import '../../../core/widget/app_date_format.dart';
import '../../../core/widget/app_dilog.dart';
import '../../../core/widget/my_appbar.dart';

import '../../notification/screen/notification_screen.dart';
import '../controller/chat_controller.dart';
import '../model/chat_room_list_model.dart';
import '../service/chat_socket_service.dart';
import '../widget/chat_empty_card.dart';
import '../widget/chat_list_shimmer.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> with SingleTickerProviderStateMixin {
  final controller = Get.find<ChatController>();
  final socket = ChatSocketService();

  late TabController tabController;

  bool _isDelete = false;
  List<int> selectedRoomIds = [];

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);

    socket.connectRooms(
      userId: controller.currentUserId!,
      onEvent: (data) {
        final type = data["type"];

        if (type == "room_created") {
          controller.fetchRooms();
        }

        if (type == "room_deleted_bulk") {
          final ids = List<int>.from(data["room_ids"]);

          controller.roomList.removeWhere(
                (e) => ids.contains(e.roomId),
          );
          controller.roomList.refresh();
        }
      },
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    socket.close();
    super.dispose();
  }

  /// FILTER
  List<ChatRoomListModel> get filteredRooms {
    final userId = controller.currentUserId;

    if (tabController.index == 1) {
      return controller.roomList
          .where((e) => e.buyerId == userId)
          .toList();
    }

    if (tabController.index == 2) {
      return controller.roomList
          .where((e) => e.sellerId == userId)
          .toList();
    }

    return controller.roomList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,

      appBar: myAppBar(
        title: "Chats",
        titleColor: AppColor.white,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        actions: [

          if (_isDelete)
            AppCard(
              color: Colors.white.withOpacity(0.15),
              borderRadius: context.sWidth * 0.02,
              padding: EdgeInsets.all(context.sWidth * 0.018),
              margin: EdgeInsets.zero,
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: context.sWidth * 0.05,
              ),
              onTap: () async {
                if (selectedRoomIds.isEmpty) {
                  FlutterToast.error("Please select chat");
                  return;
                }

                final confirm = await AppDialog.show(
                  context,
                  title: "Delete Chats",
                  message: "Are you sure you want to delete ${selectedRoomIds.length} chats?",
                  confirmText: "Delete",
                );

                if (!confirm) return;

                // 🔥 SINGLE CALL (NO LOOP)
                await controller.deleteRooms(selectedRoomIds);

                setState(() {
                  _isDelete = false;
                  selectedRoomIds.clear();
                });

                FlutterToast.success("Deleted successfully");
              },
            ),


          SizedBox(width: context.sWidth*0.06,),
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
          SizedBox(width: context.sWidth*0.04,),

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
          return const ChatListShimmer();
        }

        final rooms = filteredRooms;

        if (rooms.isEmpty) {
          return const ChatEmptyCard();
        }

        return ListView.separated(
          padding: EdgeInsets.all(context.sWidth * 0.03),
          itemCount: rooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),

            itemBuilder: (context, index) {
              final room = rooms[index];
              final currentUserId = controller.currentUserId;

              /// current user seller hai ya buyer
              final bool isSelfOwner =
                  room.sellerId == currentUserId;

              final String displayName = isSelfOwner
                  ? room.buyerName
                  : room.sellerName;

              final String displayProfile = isSelfOwner
                  ? room.buyerImage
                  : room.sellerImage;

              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isDelete = true;
                    selectedRoomIds = [room.roomId];
                  });
                },
                onTap: () {
                  if (_isDelete) {
                    setState(() {
                      if (selectedRoomIds.contains(room.roomId)) {
                        selectedRoomIds.remove(room.roomId);
                      } else {
                        selectedRoomIds.add(room.roomId);
                      }

                      if (selectedRoomIds.isEmpty) {
                        _isDelete = false;
                      }
                    });
                    return;
                  }

                  Get.toNamed(
                    "/chat-page",
                    arguments: {
                      "roomId": room.roomId,
                      "title": displayName,
                      "profile": displayProfile,
                    },
                  );
                },
                child: Stack(
                  children: [
                    AppCard(
                      margin: EdgeInsets.only(
                        bottom: context.sWidth * 0.02,
                      ),
                      padding: EdgeInsets.all(
                        context.sWidth * 0.02,
                      ),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          /// HEADER
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(
                                  context.sWidth * 0.03,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  room.service.serviceImage,
                                  fit: BoxFit.cover,
                                  width: context.sHeight * 0.1,
                                  height:
                                  context.sHeight * 0.1,
                                  placeholder:
                                      (context, url) =>
                                      Container(
                                        color: Colors.grey[100],
                                        alignment:
                                        Alignment.center,
                                        child: FaIcon(
                                          FontAwesomeIcons
                                              .chalkboardTeacher,
                                          color:
                                          Colors.grey[400],
                                          size:
                                          context.sWidth *
                                              0.06,
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) =>
                                      Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons
                                              .broken_image_outlined,
                                          color: Colors.grey,
                                          size: 25,
                                        ),
                                      ),
                                ),
                              ),

                              SizedBox(
                                width: context.sWidth * 0.03,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          displayName,
                                          style:
                                          GoogleFonts.poppins(
                                            fontWeight:
                                            FontWeight.w600,
                                            fontSize:
                                            context.text14,
                                          ),
                                        ),

                                        if (_isDelete)
                                          SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: Transform.scale(
                                              scale: 1,
                                              child: Checkbox(
                                                value: selectedRoomIds.contains(room.roomId),
                                                activeColor: AppColor.primary,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      selectedRoomIds.add(room.roomId);
                                                    } else {
                                                      selectedRoomIds.remove(room.roomId);
                                                    }

                                                    if (selectedRoomIds.isEmpty) {
                                                      _isDelete = false;
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    Row(
                                      spacing: 4,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.done_all,
                                          size: 16,
                                          color: Colors.blue,
                                        ),
                                        Expanded(
                                          child: Text(
                                            room.lastMessage
                                                .isEmpty
                                                ? "Start conversation"
                                                : room
                                                .lastMessage,
                                            maxLines: 3,
                                            overflow:
                                            TextOverflow
                                                .ellipsis,
                                            style:
                                            GoogleFonts
                                                .poppins(
                                              fontWeight:
                                              FontWeight
                                                  .w400,
                                              fontSize:
                                              context
                                                  .text12,
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          /// FOOTER
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              AppCard(
                                color: AppColor.primary
                                    .withOpacity(0.08),
                                padding:
                                EdgeInsets.symmetric(
                                  horizontal:
                                  context.sWidth *
                                      0.04,
                                  vertical:
                                  context.sWidth *
                                      0.01,
                                ),
                                margin: EdgeInsets.zero,
                                child: Text(
                                  room.service.serviceName,
                                  style:
                                  GoogleFonts.poppins(
                                    fontSize:
                                    context.text12,
                                    color:
                                    AppColor.primary,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ),
                              ),

                              Text(
                                AppDateFormat.timeDateFormat(
                                  room.updatedAt,
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                  AppColor.subtitle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (isSelfOwner)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: AppCard(
                          margin: EdgeInsets.zero,
                          color: Colors.green,
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: const Text(
                            "Self Owner",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight:
                              FontWeight.w500,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
            );
      }),
    );
  }
}