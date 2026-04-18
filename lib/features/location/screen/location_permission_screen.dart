import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/features/location/controller/location_controller.dart';

class LocationPermissionScreen extends StatelessWidget {
  LocationPermissionScreen({super.key});

  final _locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Obx(
              () => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Location Icon
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    size: 60,
                    color: Colors.orange.shade700,
                  ),
                ),

                const SizedBox(height: 30),

                /// Title
                const Text(
                  "Enable Location",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                /// Subtitle
                const Text(
                  "We need your location permission to show nearby services and better experience.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                /// Allow Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _locationController.isLoading.value
                        ? null
                        : () async {
                      await _locationController.requestLocationPermission();

                      if (_locationController.permissionGranted.value) {
                        Get.offAllNamed('/dashboard');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _locationController.isLoading.value
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Allow Location",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Skip Button
                TextButton(
                  onPressed: () {
                    Get.offAllNamed('/dashboard');
                  },
                  child: const Text(
                    "Skip for now",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}