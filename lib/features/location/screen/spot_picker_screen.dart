import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_button.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/widget/my_appbar.dart';
import '../../home/controller/home_scroll_controller.dart';
import '../controller/location_controller.dart';

class SpotPickerScreen extends StatefulWidget {
  const SpotPickerScreen({super.key});

  @override
  State<SpotPickerScreen> createState() => _SpotPickerScreenState();
}

class _SpotPickerScreenState extends State<SpotPickerScreen> {
  final LocationController locationController = Get.find<LocationController>();
  late final MapController mapController;

  LatLng? selected;
  LatLng? current;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    locationController.resetTemp();
    selected = _initialLocation();
    _loadCurrent();
  }

  LatLng _initialLocation() {
    if (locationController.tempLat.value != 0 && locationController.tempLng.value != 0) {
      return LatLng(locationController.tempLat.value, locationController.tempLng.value);
    }
    return const LatLng(20.5937, 78.9629);
  }

  Future<void> _loadCurrent() async {
    final pos = await locationController.getCurrentLatLng();
    if (pos != null && mounted) {
      setState(() => current = pos);
    }
  }

  // Instant move without animation
  Future<void> goCurrent() async {
    setState(() => loading = true);
    final pos = await locationController.getCurrentLatLng();

    if (pos != null) {
      current = pos;
      mapController.move(pos, 16); // Instant jump
      await locationController.setTempLocation(pos.latitude, pos.longitude);
      setState(() => selected = pos);
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: "Set Delivery Location",
        showBackButton: true,
        backgroundColor: AppColor.primary,
        titleColor: Colors.white,
        buttonColor: Colors.white,
      ),
      body: Stack(
        children: [
          // 1. Map
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: selected!,
              initialZoom: 15,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  // Instant update on drag
                  selected = position.center;
                }
              },
              onMapEvent: (event) {
                if (event is MapEventMoveEnd) {
                  // Fetch address only when map stops
                  locationController.setTempLocation(selected!.latitude, selected!.longitude);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png",
              ),
              if (current != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: current!,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.my_location,color: Colors.blue,),
                      ),

                    ),
                  ],
                ),
            ],
          ),

          // 2. Fixed Center Marker (Static)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      // color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Text("Location is here",
                        style: GoogleFonts.poppins(color: AppColor.primary, fontSize: 10,fontWeight: FontWeight.w600)),
                  ),
                  Icon(Icons.location_on, size: 45, color: AppColor.primary),
                ],
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: 140,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: loading ? null : goCurrent,
              child: loading
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primary),
              )
                  : Icon(Icons.my_location, color: AppColor.primary),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              top: false,
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Address Display Section
                  Row(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.location_on, color: AppColor.primary, size: 24),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Location",
                              style: GoogleFonts.poppins(color: AppColor.title, fontSize: context.text10),
                            ),
                            const SizedBox(height: 2),
                            Obx(() {
                              final address = locationController.tempCity.value.isEmpty ? "Fetching location..."
                                  : "${locationController.tempArea.value} ${locationController.tempCity.value}";
                              return Text(
                                address,
                                style: GoogleFonts.poppins(color: AppColor.title, fontSize: context.text16,fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),

                  AppButton(
                    isLoading: false,
                    onPressed: () async {
                      await locationController.confirmLocation();
                      // Get.offAllNamed('/dashboard');
                      Get.until((route) => route.settings.name == '/dashboard');
                    },
                    text: "Confirm",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}