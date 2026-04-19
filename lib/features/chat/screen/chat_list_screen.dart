import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/app_error_card.dart';
import '../../../core/widget/app_dilog.dart';
import '../controller/booking_controller.dart';
import '../../notification/screen/notification_screen.dart';
import '../controller/booking_delete_controller.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final bookingController = Get.find<BookingController>();
  final deleteController = Get.find<BookingDeleteController>();

  List<int> selectedIds = [];

  bool showActionBar = false;

  void toggleSelection(int id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }

      showActionBar = selectedIds.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColor.surface,
        appBar: AppBar(
          backgroundColor: AppColor.primary,
          title: showActionBar
              ? Text("(${selectedIds.length}) Selected")
              : Text("Chats"),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: context.text16,
            fontWeight: FontWeight.w500,
          ),
          actions: [
            if (showActionBar)
            AppCard(
              color: Colors.white.withOpacity(0.15),
              borderRadius: context.sWidth*0.02,
              padding: EdgeInsets.all( context.sWidth*0.018,),
              child:  Icon(
                Icons.delete,
                color: Colors.white,
                size: context.sWidth*0.05,
              ),
              onTap: () async {
                final confirm = await AppDialog.show(context,
                  title: "Delete Chat",
                  message: "Are you sure you want to delete?",
                  cancelText: "Cancel",
                  confirmText: "Delete",
                );
                if (confirm) {
                  for (var id in selectedIds) {
                    await deleteController.deleteBooking(id);
                  }

                  Get.find<BookingController>().fetchBookings();

                  setState(() {
                    selectedIds.clear();
                    showActionBar = false;
                  });
                }
              },
            ),

            AppCard(
              color: Colors.white.withOpacity(0.15),
              borderRadius: context.sWidth*0.02,
              padding: EdgeInsets.all( context.sWidth*0.018,),
              child:  Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: context.sWidth*0.05,
              ),
              onTap: () => Get.to(() => NotificationScreen()),
            ),
            SizedBox(width: context.sWidth*0.02,)
          ],
        ),

        body: Column(
          children: [
            _buildTabBar(context),

            Expanded(
              child: Obx(() {
                if (bookingController.isLoading.value) {
                  return  Center(child: CircularProgressIndicator(color: AppColor.primary,));
                }

                if (bookingController.errorMessage.isNotEmpty) {
                  return AppErrorCard(
                    message: bookingController.errorMessage.value,
                    title: "Connection Problem",
                    onRetry: () => bookingController.fetchBookings(),
                  );
                }

                return TabBarView(
                  children: [
                    // ALL
                    _ChatTabContent(
                      list: bookingController.all,
                      selectedIds: selectedIds,
                      toggleSelection: toggleSelection,
                      showActionBar: showActionBar,
                    ),

                    // BUYING
                    _ChatTabContent(
                      list: bookingController.buyingChats,
                      selectedIds: selectedIds,
                      toggleSelection: toggleSelection,
                      showActionBar: showActionBar,
                    ),

                    // SELLING
                    _ChatTabContent(
                      list: bookingController.sellingChats,
                      selectedIds: selectedIds,
                      toggleSelection: toggleSelection,
                      showActionBar: showActionBar,
                    ),
                  ],
                );

              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: AppColor.primary,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: context.text12,
        ),
        indicatorColor: Colors.white,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "ALL"),
          Tab(text: "BUYING"),
          Tab(text: "SELLING"),
        ],
      ),
    );
  }
}

class _ChatTabContent extends StatelessWidget {
  final List list;
  final List<int> selectedIds;
  final Function(int) toggleSelection;
  final bool showActionBar;

  const _ChatTabContent({
    required this.list,
    required this.selectedIds,
    required this.toggleSelection,
    required this.showActionBar,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      itemCount: list.length,
      padding:  EdgeInsets.only(
          top: context.sWidth*0.04,bottom: context.sHeight*0.1
      ),
      itemBuilder: (context, index) {
        final item = list[index];

        return ChatSkillCard(
          item: item,
          isSelected: selectedIds.contains(item.id),
          onLongPress: () => toggleSelection(item.id),
          onTap: () {
            if (showActionBar) {
              toggleSelection(item.id);
            } else {
              Get.toNamed(
                '/chat',
                arguments: {
                  "chatItem": item,   // 👈 FULL OBJECT PASS
                  "index": index,
                },
              );
                 }
          },
          showActionBar: showActionBar,
        );
      },
    );
  }
}

class ChatSkillCard extends StatelessWidget {
  final dynamic item;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final bool showActionBar;

  const ChatSkillCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onLongPress,
    required this.onTap,
    required this.showActionBar,
  });

  @override
  Widget build(BuildContext context) {
    final service = item.service;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Stack(
        children: [
          AppCard(
            margin:  EdgeInsets.only(bottom: context.sWidth*0.02, left: context.sWidth*0.03, right: context.sWidth*0.03),
            padding: EdgeInsets.all(context.sWidth*0.02),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: context.sWidth*0.08,
                      backgroundColor: AppColor.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(context.sHeight*0.036,),
                        child: CachedNetworkImage(
                          imageUrl: service.userProfile!.userImage.toString(),
                          fit: BoxFit.cover,
                          width: context.sHeight*0.068,
                          height: context.sHeight*0.068,
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
                            child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(service.userProfile!.userName.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: context.text12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.title,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(width: context.sWidth*0.12,height: context.sWidth*0.05,color: Colors.transparent,)
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.work_outline,
                                  size: 13, color: AppColor.subtitle),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  "${service.userProfile!.userBio.toString()}",
                                  style: GoogleFonts.poppins(
                                      fontSize: context.text12,
                                      color: AppColor.subtitle),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.done_all,
                                size: 16,
                                color: item.status == "seen"
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              Expanded(
                                child: Text(
                                  "${item.message}",
                                  style: TextStyle(
                                    fontSize: context.text12,
                                    color: AppColor.subtitle,
                                    height: 1.45,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [

                    AppCard(
                      color: AppColor.primary.withOpacity(0.08),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      margin: EdgeInsets.zero,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.computer_rounded,
                              size: 11, color: AppColor.primary),
                          const SizedBox(width: 5),
                          Text("${service.serviceName}",
                            style: GoogleFonts.poppins(
                              fontSize: context.text10,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    Text(
                      item.createdAt.toString().substring(0,10),
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColor.subtitle),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              top: 5,right: 20,
              child: showActionBar
                  ?Checkbox(
                activeColor: AppColor.primary,
                side: const BorderSide(color: Colors.grey, width: 2),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: isSelected, onChanged: (_) => onLongPress(),)
                  : SizedBox())
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          FaIcon(FontAwesomeIcons.comment,
              size: context.sWidth*0.14, color: AppColor.primary),
          SizedBox(height: 10),
          Text("No chats found",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          Text("Start booking services to chat",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: context.text12,color: Colors.grey)),
        ],
      ),
    );
  }
}