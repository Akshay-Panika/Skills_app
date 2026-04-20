import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/my_appbar.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';
import '../../../core/widget/app_dilog.dart';
import '../../../core/widget/app_error_card.dart';
import '../../auth/helper/auth_preferences.dart';
import '../controller/booking_check_controller.dart';
import '../controller/booking_create_controller.dart';
import '../controller/recent_view_controller.dart';
import '../controller/service_details_controller.dart';
import '../widget/service_details_shimmer.dart';
import 'package:path_provider/path_provider.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  const ServiceDetailsScreen({
    super.key,
    required this.serviceId,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final userId = AuthPreferences.getUserId();

  final serviceController = Get.find<ServiceDetailsController>();
  final checkBookingController = Get.find<BookingCheckController>();
  final bookingCreateController = Get.find<BookingCreateController>();
  final recentController = Get.find<RecentViewController>();

  bool _bookmark = false;
  bool _isMSG = false;
  final descController = TextEditingController();


  @override
  void initState() {
    super.initState();
    recentController.startTracking(widget.serviceId);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkBookingController.checkServiceBooking(
        int.parse(widget.serviceId),
      );

      await serviceController.fetchServiceDetails(
        int.parse(widget.serviceId),
      );

      if (!mounted) return;

      final service = serviceController.serviceDetails.value;

      if (service != null) {
        if (!mounted) return;
        descController.text =
        "Hi, I came across your \"${service.serviceName}\" skill and would like to connect.";
      }
    });
  }

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (serviceController.isLoading.value) {
        return const Scaffold(
          body: ServiceDetailsShimmer(),
        );
      }

      if (serviceController.errorMessage.isNotEmpty) {
        debugPrint("Error ${serviceController.errorMessage.value}");

        return Scaffold(
          appBar: myAppBar(title: 'Skill Details',
              backgroundColor: AppColor.primary,
              titleColor: Colors.white,
              showBackButton: true,
              buttonColor: AppColor.white
          ),
          body: Center(
            child: AppErrorCard(
              message: serviceController.errorMessage.value,
              title: "Connection Problem",
              onRetry: () => serviceController
                  .fetchServiceDetails(int.parse(widget.serviceId)),
            ),
          ),
        );
      }

      final service = serviceController.serviceDetails.value;

      if (service == null) {
        return Scaffold(
          body: Center(
            child: Text("No service data found.", style: TextStyle(fontSize: context.text16)),
          ),
        );
      }

      return Scaffold(
        backgroundColor: AppColor.surface,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight:  context.sWidth*0.7,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: const CircleAvatar(
                        backgroundColor: Colors.black38,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          shareServiceWithImage();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.black38,
                          child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: FaIcon(FontAwesomeIcons.shareFromSquare,color: Colors.white,)
                          ),
                        ),
                      ),
                    ),

                  ],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: context.sWidth*0.1,
                            right: context.sWidth*0.1,top: context.sWidth*0.01
                          ),
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                              )
                          ),
                          child:  Text(
                            service.serviceAmount != null
                                ? "₹${double.tryParse(service.serviceAmount.toString())?.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '') ?? service.serviceAmount!}"
                                : "Free",
                            style: GoogleFonts.poppins(
                                color: service.serviceAmount != null ?AppColor.white: AppColor.white,
                                fontWeight: FontWeight.w500,
                                fontSize: context.text16),
                          ),
                        )
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                      imageUrl: service.serviceImage.toString(),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        alignment: Alignment.center,
                        child: FaIcon(
                          FontAwesomeIcons.chalkboardTeacher,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40),
                      ),
                    )
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: context.sWidth*0.03,),),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: context.sWidth*0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Service Name
                              Text(
                                service.serviceName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.text16,
                                  color: AppColor.title,
                                ),
                              ),

                              SizedBox(height: context.sHeight * 0.008),
                              AppCard(
                                hasBorder: true,
                                padding:  EdgeInsets.symmetric(horizontal: context.sWidth*0.03, vertical: context.sWidth*0.01),
                                color: AppColor.primary.withOpacity(0.03),
                                margin: EdgeInsets.zero,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      service.category?.categoryName ?? "Category",
                                      style: GoogleFonts.poppins(
                                        color: AppColor.primary,
                                        fontSize: context.text12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(height: 1,width: 10,color: AppColor.primary,),
                                    SizedBox(width: context.sWidth*0.03,),
                                    Text(
                                      service.subcategory?.subcategoryName ?? "Subcategory",
                                      style: GoogleFonts.poppins(
                                        color: AppColor.title,
                                        fontSize: context.text12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: context.sHeight * 0.015),

                              Text(
                                service.serviceDescription,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: AppColor.subtitle,
                                  fontSize: context.text14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: context.sWidth*0.02,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                spacing: 2,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.location_on, size: context.sHeight*0.02, color: Colors.green),

                                  Text(
                                    service.distance.toString(),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.subtitle,
                                      fontSize: context.text14,
                                    ),
                                  )
                                ],
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child:AppCard(
                  height: context.sWidth * 0.6,
                  margin: EdgeInsets.all(context.sWidth*0.03),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.ad,
                        color: Colors.grey, size: 30),
                  ),
                ),),

                if(userId != service.userProfile!.id)
                SliverToBoxAdapter(
                  child: AppCard(
                    padding:  EdgeInsets.all(context.sWidth*0.03),
                    margin: EdgeInsets.all(context.sWidth*0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TOP ROW
                        Row(
                          children: [
                            /// Profile Image
                            CircleAvatar(
                              radius: context.sHeight*0.036,
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

                            const SizedBox(width: 10),

                            /// Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Name
                                  Text(
                                    service.userProfile!.userName.toString(),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: context.text14,
                                    ),
                                  ),

                                  SizedBox(height: 2),

                                  /// Bio
                                  Text(
                                    service.userProfile!.userBio.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: AppColor.subtitle,
                                      fontSize: context.text12,
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppCard(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  color: AppColor.primary.withOpacity(0.15),
                                  margin: EdgeInsets.zero,
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, size: 14, color: Colors.amber),
                                      const SizedBox(width: 2),
                                      Text(
                                        "4.8",
                                        style: GoogleFonts.poppins(
                                          fontSize: context.text12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "120 reviews",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: context.text10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),


                        SizedBox(height: context.sHeight * 0.012),

                        /// Divider
                        Divider(height: 1, color: Colors.grey.withOpacity(0.2)),

                        SizedBox(height: context.sHeight * 0.03),

                        InkWell(
                          onTap: () async {
                            final message = await AppDialog.showWithInput(
                              context,
                              title: "Report Skill",
                              hintText: "Write your issue here...",
                              confirmText: "Report",
                            );

                            if (message != null && message.isNotEmpty) {
                              print("User message: $message");
                            }
                          },
                          child: Center(
                            child: Text(
                              "Report this skill",
                              style: GoogleFonts.poppins(
                                color: Colors.red.withOpacity(0.7),
                                fontSize: context.text12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: context.sWidth*0.3,),),

              ],
            ),
            if(userId != service.userProfile!.id)
            Positioned(
              bottom: context.sWidth * 0.06,
              left: 0,
              right: 0,
              child: Obx(() {

                final alreadyBooked = checkBookingController.alreadyBooked.value;

                if (alreadyBooked) {
                  return _actionButton(
                    context,
                    loading: checkBookingController.isLoading.value,
                    text: "Skill Booked",
                    onChatTap: () {
                      Get.toNamed(
                        '/chat',
                        arguments: {
                          "serviceId": service.id,
                        },
                      );
                    },
                    // onChatTap: () => Get.to(() => ChatScreen()),
                    bookmark: _bookmark,
                    onBookmarkTap: () {
                      setState(() {
                        _bookmark = !_bookmark;
                      });
                    },
                  );
                }

                return Column(
                  children: [

                    if (_isMSG)
                      Stack(
                        children: [
                          AppCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel(context, "Chat With Mentor"),
                                _mxgBox(controller: descController),
                              ],
                            ),
                          ),

                          Positioned(
                            top: 0,
                            right: 16,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isMSG = false;
                                  descController.text =
                                  "Hi, I came across your \"${service.serviceName}\" skill and would like to connect with you.";
                                });
                              },
                              icon: const Icon(Icons.close, color: Colors.red),
                            ),
                          ),
                        ],
                      ),

                    _actionButton(
                      context,
                      loading: checkBookingController.isLoading.value,
                      text: _isMSG ? "Send Message" : "Chat With Mentor",
                      onChatTap: () {
                        if (!_isMSG) {
                          setState(() {
                            _isMSG = true;
                          });
                          return;
                        }

                        bookingCreateController.createBooking(
                          serviceId: service.id,
                          message: descController.text,
                        );
                      },

                      bookmark: _bookmark,
                      onBookmarkTap: () {
                        setState(() {
                          _bookmark = !_bookmark;
                        });
                      },
                    ),
                  ],
                );
              }),
            ),

            if(userId == service.userProfile!.id)
              Positioned(
                bottom: context.sWidth * 0.06,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 16),
                      child: Text(
                        "Self Mentor",
                        style: GoogleFonts.poppins(
                          fontSize: context.text14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                          "You are your own mentor—guide your journey, track your growth, and become your best version."
                          , style: TextStyle(
                          fontSize: context.text14,
                          color: AppColor.subtitle ,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    AppCard(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      height: context.sWidth * 0.12,
                      color: AppColor.primary,
                      onTap: () => Get.back(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.settings_backup_restore_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Back',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: context.text14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );

    });
  }

  Future<void> shareServiceWithImage() async {
    final service = serviceController.serviceDetails.value;

    if (service == null) return;

    try {
      /// 1. Download image
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/service.jpg';

      await Dio().download(service.serviceImage.toString(), filePath);

      /// 2. Share text (clean & professional)
      final text = '''
🚀 Skills Daan App – Discover Amazing Skills & Services!

🔥 ${service.serviceName ?? "Amazing Skill"}

📌 ${service.serviceDescription ?? "Learn real skills from experts."}

💰 Price: ${service.serviceAmount != null ? "₹${service.serviceAmount}" : "Free"}

📍 Distance: ${service.distance ?? "Nearby"}

👨‍💻 Book & Learn Skills Easily

👉 Download App: https://your-app-link.com

#SkillsDaan #SkillSharing #EarnAndLearn
''';

      /// 3. Share image + text
      await Share.shareXFiles(
        [XFile(filePath)],
        text: text,
      );
    } catch (e) {
      debugPrint("Share Error: $e");
    }
  }

  Widget _fieldLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: context.text14,
          color: AppColor.subtitle,
        ),
      ),
    );
  }
  Widget _mxgBox({
    TextEditingController? controller,
  }){
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColor.primary.withOpacity(.1), width: 1.2),
    );

    return TextField(
      maxLines: 4,
      minLines: 3,
      keyboardType: TextInputType.multiline,
      controller: controller,
      style: TextStyle(color: AppColor.title, fontSize: context.text14),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.surface,
        hintText: "Enter description...",
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.all(12),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintStyle: TextStyle(color: AppColor.subtitle, fontSize: context.text14),
      ),
    );
  }

}

Widget _actionButton(
    BuildContext context, {
      required bool loading,
      required String text,
      required bool bookmark,
      required VoidCallback onBookmarkTap,
      VoidCallback? onChatTap,

    }) {
  return Row(
    children: [

      Expanded(
        child: AppCard(
          height: context.sWidth * 0.12,
          color: AppColor.primary,
          onTap:onChatTap,
          child:
          loading ?
          Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
          :
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.chat, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                text,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: context.text14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(width: 10),

      /// 🔖 Bookmark Button
      AppCard(
        height: context.sWidth * 0.12,
        width: context.sWidth * 0.12,
        color: AppColor.primary,
        onTap: onBookmarkTap,
        child: Icon(
          bookmark ? Icons.bookmark : Icons.bookmark_border,
          color: Colors.white,
        ),
      ),
    ],
  );
}

String getDistanceText(double lat1, double lon1, double lat2, double lon2) {
  final distanceKm = Geolocator.distanceBetween(
    lat1,
    lon1,
    lat2,
    lon2,
  ) / 1000;

  if (distanceKm < 1) {
    return "${(distanceKm * 1000).round()} m";
  } else {
    return "${distanceKm.toStringAsFixed(1)} km";
  }
}