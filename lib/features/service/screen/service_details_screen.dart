// servicedetails/view/service_details_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/app_contact.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';
import '../../account/controller/user_profile_controller.dart';
import '../../account/model/user_profile_model.dart';
import '../controller/service_details_controller.dart';
import '../widget/service_details_shimmer.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  final String distanceText;

  const ServiceDetailsScreen({
    super.key,
    required this.distanceText,
    required this.serviceId,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  late final ServiceDetailsController serviceController;
  final UserProfileController userProfileController = Get.put(UserProfileController());

  bool _bookmark = false;

  @override
  void initState() {
    super.initState();
    serviceController = Get.put(ServiceDetailsController());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 1. Fetch service details
      await serviceController.fetchServiceDetails(int.parse(widget.serviceId));

      // 2. Fetch seller profile after service is loaded
      final service = serviceController.serviceDetails.value;
      if (service != null) {
        await userProfileController.fetchUserProfile(service.user);
      }
    });
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
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
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
                      background: (service.serviceImage != null &&
                          service.serviceImage!.isNotEmpty)
                          ? Image.network(
                        service.serviceImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                          : _imagePlaceholder(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TITLE & PRICE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  service.serviceName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: context.text16),
                                ),
                              ),
                              Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    service.serviceAmount != null
                                        ? "₹${double.tryParse(service.serviceAmount!)?.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '') ?? service.serviceAmount!}"
                                        : "Free",
                                    style: TextStyle(
                                        color: service.serviceAmount != null ? Colors.green: AppColor.primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: context.text16),
                                  ),
                                  Row(
                                    spacing: 2,
                                    children: [
                                      Icon(Icons.location_on, size: context.sHeight*0.02, color: Colors.green),
              
                                      Text(
                                        widget.distanceText,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.subtitle, fontSize: context.text14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "Description",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500, fontSize: context.text16),
                          ),
                          SizedBox(height: context.sHeight * 0.008),
                          Text(
                            service.serviceDescription,
                            style:
                            TextStyle(color: AppColor.subtitle, fontSize: context.text16),
                          ),
                          SizedBox(height: context.sHeight * 0.02),
                          AppCard(
                            height: context.sWidth * 0.6,
                            margin: EdgeInsets.zero,
                            // hasBorder: true,
                            child: const Center(
                              child: FaIcon(FontAwesomeIcons.ad,
                                  color: Colors.grey, size: 30),
                            ),
                          ),
                          SizedBox(height: context.sHeight * 0.02),
                          // SELLER INFO
                          Obx(() {
                            if (userProfileController.isLoading.value) {
                              return _sellerShimmer();
                            }
              
                            final UserProfileModel? profile =
                                userProfileController.userProfile.value;
              
                            if (profile == null) return _sellerShimmer();
              
                            return AppCard(
                              padding: const EdgeInsets.all(16),
                              margin: EdgeInsets.zero,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.grey.withOpacity(.15),
                                    backgroundImage: (profile.userImage != null &&
                                        profile.userImage!.isNotEmpty)
                                        ? NetworkImage(profile.userImage!)
                                        : null,
                                    child: (profile.userImage == null ||
                                        profile.userImage!.isEmpty)
                                        ? const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 32,
                                      color: Colors.grey,
                                    )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profile.userName ?? '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: context.text16),
                                        ),
                                        SizedBox(height: context.sHeight * 0.005),
                                        Text(
                                          profile.userBio ?? '',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: context.text14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          SizedBox(height: context.sHeight * 0.03),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Obx(() {
              final UserProfileModel? profile = userProfileController.userProfile.value;
              return  Row(
                children: [
                  Expanded(
                    child: AppCard(
                      height: context.sWidth*0.12,
                      color: AppColor.primary,
                      onTap: () => AppContact.whatsapp(profile!.userPhone, 'Hello Sir, I want to this course!'),
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat, color: Colors.white),
                          Text(
                            "Chat With Mentor",
                            style: TextStyle(color: Colors.white, fontSize: context.text14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppCard(
                    color: AppColor.primary,
                    height: context.sWidth*0.12,
                    width: context.sWidth*0.12,
                    onTap: () => setState(() => _bookmark = !_bookmark),
                    child: Icon(
                      _bookmark ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: context.sHeight*0.03,)
          ],
        ),
      );
    });
  }

  Widget _imagePlaceholder() => Container(
    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.16)),
    child: const Center(
      child: Icon(Icons.image_not_supported_outlined,
          size: 100, color: Colors.white),
    ),
  );

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
