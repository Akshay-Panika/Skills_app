import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:skills_app/features/chat/screen/chating_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../account/controller/user_profile_controller.dart';
import '../../account/model/user_profile_model.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../chat/service/chat_api_service.dart';
import '../model/service_list_model.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  final List<ServiceListModel> services;
  final String distanceText;
  const ServiceDetailsScreen({
    super.key,
    required this.serviceId,
    required this.services, required this.distanceText,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {

  final UserProfileController controller = Get.put(UserProfileController());

  int? currentUserId;
  late ServiceListModel service;

  bool _bookmark = false;

  @override
  void initState() {
    super.initState();
    loadUser();

    service = widget.services.firstWhere(
          (s) => s.id.toString() == widget.serviceId,
      orElse: () => ServiceListModel(
        id: 0,
        serviceName: "Service Not Found",
        serviceDescription: "",
        serviceImage: "",
        serviceAmount: "0",
        serviceStatus: false,
        user: 0,
        category: 0,
        subcategory: 0,
      ),
    );

    controller.fetchUserProfile(service.user);
  }

  void loadUser() async {
    currentUserId = await AuthPreferences.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: CustomScrollView(
        slivers: [
          /// IMAGE SECTION
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(30),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: service.serviceImage.isNotEmpty
                  ? Image.network(
                service.serviceImage,
                fit: BoxFit.cover,
              )
                  : Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.16),
                ),
                child: const Center(
                  child: Icon(Icons.image_not_supported_outlined,
                      size: 100, color: Colors.white),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// SERVICE TITLE & PRICE
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
                      Row(
                        children: [
                          Text(
                              service.serviceAmount != null
                                  ? "₹${service.serviceAmount}"
                                  : "Free",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// LOCATION + DISTANCE
                  Row(
                    children:  [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        "${widget.distanceText}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// DESCRIPTION
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.serviceDescription,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),


                  Container(
                    height: 250,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(child: FaIcon(FontAwesomeIcons.ad, color: Colors.grey,size: 30,)),
                  ),


                  /// SELLER INFO
                  Obx((){
                    if (controller.isLoading.value) {
                      return  Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey.withOpacity(0.16),
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Text("SD Seller",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }

                    final UserProfileModel? profile = controller.userProfile.value;

                    // Null state
                    if (profile == null) {
                      return  Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey.withOpacity(0.16),
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Text("SD Seller",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }

                    return  Stack(
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
                                backgroundColor: Colors.grey.withOpacity(.15),
                                backgroundImage: profile.userImage != null && profile.userImage!.isNotEmpty
                                    ? NetworkImage(profile.userImage!)
                                    : null,
                                child: profile.userImage == null || profile.userImage!.isEmpty
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
                                    Text("${profile.userName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text("${profile.userBio}",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Positioned(
                          right: 10,top: 10,
                          child:  Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 16),
                            SizedBox(width: 2),
                            Text(
                              "${4.5 ?? 4.5}", // default
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "(${20 ?? 20} reviews)",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),)
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

      /// CHAT BUTTON

      bottomNavigationBar:
      (currentUserId != null && currentUserId != service.user)
          ?
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 30),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    openWhatsApp("+918989207770", "Hello Seller I want to this course!");
                  },
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: const Text(
                    "Chat With Mentor",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _bookmark = !_bookmark;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child:  Icon(_bookmark ? Icons.bookmark:Icons.bookmark_border, color: Colors.white),
              )
            ],
          ),
        ),
      )
      :Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 30),
        child: SizedBox(
          height: 40,
          child:  ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon:  FaIcon(FontAwesomeIcons.ad, color: Colors.white),
            label: const Text(
              "Self Mentor",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }
}



void openWhatsApp(String phone, String message) async {
  final url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');

  try {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    print("Error launching WhatsApp: $e");
  }
}