// servicedetails/view/service_details_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constant/app_color.dart';
import '../../account/controller/user_profile_controller.dart';
import '../../account/model/user_profile_model.dart';
import '../../auth/helper/auth_preferences.dart';
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
  final UserProfileController userProfileController = Get.put(UserProfileController());
  late final ServiceDetailsController serviceController;

  int? currentUserId;
  bool _bookmark = false;

  @override
  void initState() {
    super.initState();
    serviceController = Get.put(ServiceDetailsController());
    serviceController.fetchServiceDetails(int.parse(widget.serviceId));
    loadUser();
  }

  void loadUser() async {
    currentUserId = await AuthPreferences.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// LOADING STATE
      if (serviceController.isLoading.value) {
        return  Scaffold(
          body: ServiceDetailsShimmer(),
        );
      }

      /// ERROR STATE
      if (serviceController.errorMessage.isNotEmpty) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 12),
                Text(
                  serviceController.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => serviceController
                      .fetchServiceDetails(int.parse(widget.serviceId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                ),
              ],
            ),
          ),
        );
      }

      final service = serviceController.serviceDetails.value;

      /// NULL STATE
      if (service == null) {
        return const Scaffold(
          body: Center(child: Text("No service data found.")),
        );
      }

      return Scaffold(
        backgroundColor: AppColor.surface,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.black),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                )
              ],
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
                    /// ── TITLE & PRICE ────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            service.serviceName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Text(
                          service.serviceAmount != null
                              ? "₹${service.serviceAmount}"
                              : "Free",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// ── LOCATION + DISTANCE ──────────────────────────
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          widget.distanceText,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// ── DESCRIPTION ──────────────────────────────────
                    const Text(
                      "Description",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      service.serviceDescription,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 14),
                    ),

                    /// ── AD BANNER ────────────────────────────────────
                    Container(
                      height: 250,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: FaIcon(FontAwesomeIcons.ad,
                            color: Colors.grey, size: 30),
                      ),
                    ),

                    /// ── SELLER INFO ───────────────────────────────────
                    Obx(() {
                      if (userProfileController.isLoading.value) {
                        return _sellerShimmer();
                      }

                      final UserProfileModel? profile =
                          userProfileController.userProfile.value;

                      if (profile == null) return _sellerShimmer();

                      return Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor:
                                  Colors.grey.withOpacity(.15),
                                  backgroundImage: (profile.userImage !=
                                      null &&
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profile.userName ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        profile.userBio ?? '',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Rating
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Row(
                              children: const [
                                Icon(Icons.star,
                                    color: Colors.orange, size: 16),
                                SizedBox(width: 2),
                                Text("4.5",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 6),
                                Text("(20 reviews)",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),

        /// ── BOTTOM BUTTONS ─────────────────────────────────────────
        bottomNavigationBar:
        (currentUserId != null && currentUserId != service.user)
            ? Padding(
          padding: const EdgeInsets.only(
              left: 16, right: 16, bottom: 30),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => openWhatsApp(
                      "+918989207770",
                      "Hello Seller I want to this course!",
                    ),
                    icon: const Icon(Icons.chat,
                        color: Colors.white),
                    label: const Text(
                      "Chat With Mentor",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D6E6E),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => _bookmark = !_bookmark),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6E6E),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10)),
                  ),
                  child: Icon(
                    _bookmark
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.only(
              left: 16, right: 16, bottom: 30),
          child: SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const FaIcon(FontAwesomeIcons.ad,
                  color: Colors.white),
              label: const Text(
                "Self Mentor",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D6E6E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
      );
    });
  }

  /// ── HELPERS ──────────────────────────────────────────────────────
  Widget _imagePlaceholder() => Container(
    decoration:
    BoxDecoration(color: Colors.grey.withOpacity(0.16)),
    child: const Center(
      child: Icon(Icons.image_not_supported_outlined,
          size: 100, color: Colors.white),
    ),
  );

  Widget _sellerShimmer() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.grey.withOpacity(0.16),
          child:
          const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Text("SD Seller",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

void openWhatsApp(String phone, String message) async {
  final url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
  try {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint("Error launching WhatsApp: $e");
  }
}