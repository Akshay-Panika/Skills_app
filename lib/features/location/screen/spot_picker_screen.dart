import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/widget/my_appbar.dart';
import '../../service/controller/service_list_controller.dart';
import '../controller/location_controller.dart';

class SpotPickerScreen extends StatefulWidget {
  const SpotPickerScreen({super.key});

  @override
  State<SpotPickerScreen> createState() => _SpotPickerScreenState();
}

class _SpotPickerScreenState extends State<SpotPickerScreen> {
  final LocationController _locationController = Get.find<LocationController>();

  late MapController _mapController;
  LatLng? selectedLocation;
  LatLng? currentLocation;
  bool _isLocating = false; // my location button loading

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    if (_locationController.hasLocation) {
      selectedLocation = LatLng(
        _locationController.latitude.value,
        _locationController.longitude.value,
      );
    } else {
      selectedLocation = const LatLng(20.5937, 78.9629);
    }

    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    final latLng = await _locationController.getCurrentLatLng();
    if (latLng != null && mounted) {
      setState(() => currentLocation = latLng);
    }
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _isLocating = true);
    final latLng = await _locationController.getCurrentLatLng();
    if (latLng != null && mounted) {
      setState(() {
        currentLocation = latLng;
        selectedLocation = latLng;
        _isLocating = false;
      });
      _mapController.move(latLng, 16);
      await _locationController.updateFromMapSelection(
        latLng.latitude,
        latLng.longitude,
      );
    } else {
      setState(() => _isLocating = false);
    }
  }

  Future<void> _confirmLocation() async {
    if (selectedLocation == null) return;
    await _locationController.updateFromMapSelection(
      selectedLocation!.latitude,
      selectedLocation!.longitude,
    );
    Get.find<ServiceListController>().fetchServiceList();

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: myAppBar(
        backgroundColor: AppColor.primary,
        title: "Select Location",
        buttonColor: Colors.white,
        showBackButton: true,
        titleColor: Colors.white
      ),
      body: Stack(
        children: [
          /// MAP
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: selectedLocation!,
              initialZoom: 15,
              minZoom: 5,
              maxZoom: 20,
              onTap: (tapPosition, point) async {
                setState(() => selectedLocation = point);
                await _locationController.updateFromMapSelection(
                  point.latitude,
                  point.longitude,
                );
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.skills_app',
                maxZoom: 20,
              ),
              MarkerLayer(
                markers: [
                  /// Current GPS — blue pulsing dot
                  if (currentLocation != null)
                    Marker(
                      point: currentLocation!,
                      width: 44,
                      height: 44,
                      child: _BluePulse(),
                    ),

                  /// Selected spot — red pin
                  Marker(
                    point: selectedLocation!,
                    width: 50,
                    height: 60,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Spot",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(Icons.location_on,
                            size: 36, color: AppColor.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// Top hint banner
          Positioned(
            top: 12,
            left: 20,
            right: 20,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    "Map pe tap karke spot select karo",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          /// My Location FAB
          Positioned(
            right: 16,
            bottom: 120,
            child: GestureDetector(
              onTap: _isLocating ? null : _goToCurrentLocation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _isLocating
                    ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.blue),
                )
                    : const Icon(Icons.my_location,
                    color: Colors.blue, size: 22),
              ),
            ),
          ),

          /// Bottom Sheet style card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Obx(() => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Location icon circle
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.location_on,
                        color: AppColor.primary, size: 22),
                  ),
                  const SizedBox(width: 12),

                  /// Address text
                  Expanded(
                    child: _locationController.isLoading.value
                        ? Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Address fetch ho raha hai...",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13),
                        ),
                      ],
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Selected Location",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _locationController.city.value.isEmpty
                              ? "Location select karo"
                              : '${_locationController.city.value}, ${_locationController.state.value}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// Confirm button
                  GestureDetector(
                    onTap: _confirmLocation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Confirm",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}

/// Blue pulsing dot for current location
class _BluePulse extends StatefulWidget {
  @override
  State<_BluePulse> createState() => _BluePulseState();
}

class _BluePulseState extends State<_BluePulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.withOpacity(_animation.value * 0.25),
          border: Border.all(
              color: Colors.blue.withOpacity(_animation.value), width: 2),
        ),
        child: const Center(
          child: CircleAvatar(radius: 6, backgroundColor: Colors.blue),
        ),
      ),
    );
  }
}