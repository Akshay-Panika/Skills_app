import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widget/flutter_toast.dart';
import '../../service/controller/service_delete_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../../service/screen/service_details_screen.dart';
import '../controller/service_list_by_user_controller.dart';
import '../repository/service_list_byuser_repository.dart';

// ─── Design Tokens ─────────────────────────────────────────────────────────────
class _C {
  static const primary     = Color(0xFF0D6E6E);
  static const primaryDark = Color(0xFF094F4F);
  static const accent      = Color(0xFFFFB347);
  static const surface     = Color(0xFFF4F7F7);
  static const card        = Color(0xFFFFFFFF);
  static const textDark    = Color(0xFF0D1F1F);
  static const textMid     = Color(0xFF4A6565);
  static const textLight   = Color(0xFF8AABAB);
  static const chipBg      = Color(0xFFE6F2F2);
  static const success     = Color(0xFF2ECC8A);
  static const danger      = Color(0xFFE05757);
}

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  final controller = Get.put(
    ServiceListByUserController(repository: ServiceListByUserRepository()),
  );
  final deleteController = Get.put(ServiceDeleteController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: _C.surface,
        body: Column(
          children: [
            // ── Gradient Header ──────────────────────────────────────────────
            _buildHeader(context),

            // ── Tab Content ──────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                children: [
                  // Sell tab
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Column(
                        children: [
                          LinearProgressIndicator(
                            color: _C.primary,
                            backgroundColor: _C.chipBg,
                            minHeight: 2,
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      );
                    }

                    if (controller.serviceList.isEmpty) {
                      return _EmptyState(
                        icon: Icons.storefront_outlined,
                        title: "No Ads Yet",
                        subtitle: "Your posted services will appear here",
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
                      itemCount: controller.serviceList.length,
                      itemBuilder: (context, index) {
                        final s = controller.serviceList[index];
                        return AdCard(
                          title: s.serviceName,
                          price: s.serviceAmount != null
                              ? "₹${s.serviceAmount}"
                              : "Free",
                          serviceDescription: s.serviceDescription,
                          views: "0 views",
                          image: s.serviceImage,
                          status: s.serviceStatus ? "Active" : "Inactive",
                          serviceId: s.id,
                          userId: s.user,
                        );
                      },
                    );
                  }),

                  // Buy tab
                  _EmptyState(
                    icon: Icons.shopping_bag_outlined,
                    title: "No Purchases Yet",
                    subtitle: "Services you book will appear here",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_C.primaryDark, _C.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  // IconButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  //       color: Colors.white, size: 20),
                  // ),
                  const Expanded(
                    child: Text(
                      "My Ads",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14),
                unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                indicator: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "Sell"),
                  Tab(text: "Buy"),
                ],
              ),
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

// ─── Ad Card ──────────────────────────────────────────────────────────────────
class AdCard extends StatelessWidget {
  final int    serviceId;
  final int    userId;
  final String title;
  final String serviceDescription;
  final String price;
  final String views;
  final String status;
  final String image;

  const AdCard({
    super.key,
    required this.serviceId,
    required this.userId,
    required this.title,
    required this.serviceDescription,
    required this.price,
    required this.views,
    required this.status,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final deleteController = Get.find<ServiceDeleteController>();
    final listController   = Get.find<ServiceListByUserController>();

    final bool isActive  = status == "Active";
    final bool isFree    = price == "Free";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _C.primary.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceDetailsScreen(
                services: Get.find<ServiceListController>().services,
                serviceId: serviceId.toString(),
                distanceText: serviceDescription,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image ────────────────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: image.isNotEmpty
                      ? Image.network(
                    image,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imgPlaceholder(),
                  )
                      : _imgPlaceholder(),
                ),

                const SizedBox(width: 12),

                // ── Info ─────────────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + menu
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: _C.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _popupMenu(context, deleteController, listController),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        serviceDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: _C.textMid, height: 1.4),
                      ),

                      const SizedBox(height: 10),

                      // Price + status + views
                      Row(
                        children: [
                          // Price pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isFree
                                  ? _C.success.withOpacity(0.12)
                                  : _C.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              price,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: isFree ? _C.success : _C.primary,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Status dot
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? _C.success.withOpacity(0.1)
                                  : _C.danger.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color:
                                    isActive ? _C.success : _C.danger,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color:
                                    isActive ? _C.success : _C.danger,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Views
                          Row(
                            children: [
                              const Icon(Icons.remove_red_eye_outlined,
                                  size: 12, color: _C.textLight),
                              const SizedBox(width: 3),
                              Text(
                                views,
                                style: const TextStyle(
                                    fontSize: 11, color: _C.textLight),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imgPlaceholder() {
    return Container(
      width: 90,
      height: 90,
      color: _C.chipBg,
      child: const Icon(Icons.image_not_supported_outlined,
          color: _C.textLight, size: 28),
    );
  }

  Widget _popupMenu(
      BuildContext context,
      ServiceDeleteController deleteController,
      ServiceListByUserController listController,
      ) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded,
          color: _C.textLight, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: _C.card,
      elevation: 6,
      onSelected: (value) async {
        if (value == "delete") {
          final bool? confirm = await Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: _C.card,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _C.danger.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: _C.danger, size: 28),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Delete Service?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _C.textDark),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "This action cannot be undone.\nAre you sure?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, color: _C.textMid, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(result: false),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: _C.chipBg, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text("Cancel",
                                style: TextStyle(
                                    color: _C.textMid,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _C.danger,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text("Delete",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );

          if (confirm == true) {
            await deleteController.deleteService(
                userId: userId, serviceId: serviceId);

            if (deleteController.message.value.contains("success")) {
              listController.removeService(serviceId);
              FlutterToast.success(deleteController.message.value);
              Get.find<ServiceListController>().fetchServiceList();
            } else {
              FlutterToast.error("Service not found");
            }
          }
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: "edit",
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: _C.chipBg,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.edit_outlined,
                    size: 16, color: _C.primary),
              ),
              const SizedBox(width: 10),
              const Text("Edit",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: _C.textDark)),
            ],
          ),
        ),
        PopupMenuItem(
          value: "delete",
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: _C.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.delete_outline_rounded,
                    size: 16, color: _C.danger),
              ),
              const SizedBox(width: 10),
              const Text("Delete",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: _C.danger)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String   title;
  final String   subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: _C.chipBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 44, color: _C.primary),
          ),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _C.textDark)),
          const SizedBox(height: 6),
          Text(subtitle,
              style:
              const TextStyle(fontSize: 13, color: _C.textMid)),
        ],
      ),
    );
  }
}