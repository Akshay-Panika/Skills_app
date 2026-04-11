import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/app_contact.dart';
import 'package:skills_app/features/chat/screen/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';
import '../../account/controller/user_profile_controller.dart';
import '../../account/model/user_profile_model.dart';
import '../../location/controller/location_controller.dart';
import '../controller/booking_check_controller.dart';
import '../controller/booking_create_controller.dart';
import '../controller/service_details_controller.dart';
import '../repository/booking_create_repository.dart';
import '../widget/service_details_shimmer.dart';

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
  final ServiceDetailsController serviceController = Get.find();
  final UserProfileController userProfileController = Get.find();
  final locationController = Get.find<LocationController>();
  final checkBookingController = Get.put(BookingCheckController());
  final bookingCreateController = Get.put(
    BookingCreateController(BookingCreateRepository()),
  );

  bool _bookmark = false;
  bool _isMSG = false;
  final descController = TextEditingController();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkBookingController.checkServiceBooking(
        int.parse(widget.serviceId),
      );

      await serviceController.fetchServiceDetails(
        int.parse(widget.serviceId),
      );

      final service = serviceController.serviceDetails.value;

      if (service != null) {
        await userProfileController.fetchUserProfile(service.user);

        descController.text =
        "Hi, I came across your \"${service.serviceName}\" skill and would like to connect...";
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
      if (serviceController.isLoading.value || checkBookingController.isLoading.value) {
        return const Scaffold(
          body: ServiceDetailsShimmer(),
        );
      }

      if (serviceController.errorMessage.isNotEmpty) {
        debugPrint("Error ${serviceController.errorMessage.value}");
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: context.sHeight*0.06, color: Colors.red),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric( horizontal:context.sHeight*0.06),
                  child: Text(
                    serviceController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red, fontSize: context.text16),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => serviceController
                      .fetchServiceDetails(int.parse(widget.serviceId)),
                  icon: const Icon(Icons.refresh),
                  label: Text("Retry", style: TextStyle(fontSize: context.text16)),
                ),
              ],
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
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.arrow_back_ios, color: Colors.black),
                        ),
                      ),
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
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: context.sWidth*0.06,),),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2,
                          child: Text(
                            service.serviceName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: context.text16),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                service.serviceAmount != null
                                    ? "₹${double.tryParse(service.serviceAmount.toString())?.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '') ?? service.serviceAmount!}"
                                    : "Free",
                                style: TextStyle(
                                    color: service.serviceAmount != null ? Colors.green: AppColor.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: context.text16),
                              ),
                              Row(
                                spacing: 2,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.location_on, size: context.sHeight*0.02, color: Colors.green),

                                  Obx(() {
                                    final lat = locationController.latitude.value;
                                    final lon = locationController.longitude.value;

                                    if (service.latitude == null || service.longitude == null) {
                                      return Text(
                                        "N/A",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.subtitle,
                                          fontSize: context.text14,
                                        ),
                                      );
                                    }

                                    final distanceText = getDistanceText(
                                      lat,
                                      lon,
                                      service.latitude!,
                                      service.longitude!,
                                    );

                                    return Text(
                                      distanceText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.subtitle,
                                        fontSize: context.text14,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500, fontSize: context.text16),
                        ),
                        SizedBox(height: context.sHeight * 0.002),
                        Text(
                          service.serviceDescription,
                          style:
                          TextStyle(color: AppColor.subtitle, fontSize: context.text16),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child:AppCard(
                  height: context.sWidth * 0.6,
                  margin: EdgeInsets.all(16),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.ad,
                        color: Colors.grey, size: 30),
                  ),
                ),),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child:Obx(() {
                      if (userProfileController.isLoading.value) {
                        return _sellerShimmer();
                      }

                      final UserProfileModel? profile =
                          userProfileController.userProfile.value;

                      if (profile == null) return _sellerShimmer();

                      return AppCard(
                        padding: const EdgeInsets.all(14),
                        margin: EdgeInsets.zero,
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
                                      imageUrl: profile!.userImage!,
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
                                        profile.userName ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: context.text14,
                                        ),
                                      ),

                                      SizedBox(height: 2),

                                      /// Bio
                                      Text(
                                        profile.userBio ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
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
                                            style: TextStyle(
                                              fontSize: context.text12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "120 reviews",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: context.text12,
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

                            Center(
                              child: Text(
                                "Report this skill",
                                style: TextStyle(
                                  color: Colors.red.withOpacity(0.7),
                                  fontSize: context.text12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: context.sWidth*0.3,),),

              ],
            ),
            Positioned(
              bottom: context.sWidth * 0.06,
              left: 0,
              right: 0,
              child: Obx(() {

                final alreadyBooked = checkBookingController.alreadyBooked.value;

                if (alreadyBooked) {
                  return _actionButton(
                    context,
                    text: "Skill Booked",
                    onChatTap: () => Get.to(() => ChatScreen()),
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
          ],
        ),
      );
    });
  }
  Widget _fieldLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
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
      controller: descController,
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

  Widget _sellerShimmer() =>  Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _shimmerBox(width: 64, height: 64, radius: 50),
        SizedBox(width: context.sWidth * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(width: context.sWidth * 0.4, height: context.text16),
              SizedBox(height: context.sHeight * 0.005),
              _shimmerBox(height: context.text14),
              SizedBox(height: context.sHeight * 0.002),
              // _shimmerBox(width: context.sWidth * 0.5, height: context.text14),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _shimmerBox({double? width, double? height, double radius = 8}) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 16,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

Widget _actionButton(
    BuildContext context, {
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
          onTap: onChatTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.chat, color: Colors.white),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.text14,
                ),
              ),
            ],
          ),
        ),
      ),

      SizedBox(width: 10),

      AppCard(
        color: AppColor.primary,
        height: context.sWidth * 0.12,
        width: context.sWidth * 0.12,
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