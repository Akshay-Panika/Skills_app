// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
//
//
// class LocationController extends GetxController {
//   var latitude = 0.0.obs;
//   var longitude = 0.0.obs;
//   var city = ''.obs;
//   var state = ''.obs;
//   var isLocationLoaded = false.obs;
//
//   /// Call this to fetch current location
//   Future<void> fetchLocation() async {
//     try {
//       // Show loading
//       isLocationLoaded.value = false;
//
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         print("Location services are disabled.");
//         return;
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         print("Location permission denied");
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       latitude.value = position.latitude;
//       longitude.value = position.longitude;
//
//       // Get city & state
//       List<Placemark> placemarks =
//       await placemarkFromCoordinates(latitude.value, longitude.value);
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         city.value = place.locality ?? '';
//         state.value = place.administrativeArea ?? '';
//       }
//
//       // Finished loading
//       isLocationLoaded.value = true;
//
//       print("Location fetched: ${latitude.value}, ${longitude.value}");
//       print("City: ${city.value}, State: ${state.value}");
//     } catch (e) {
//       print("Error fetching location: $e");
//       isLocationLoaded.value = true; // Stop loading on error
//     }
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var city = ''.obs;
  var state = ''.obs;

  var isLoading = false.obs;
  var permissionGranted = false.obs;

  Future<void> requestLocationPermission() async {
    isLoading.value = true;

    try {
      // 1. Check if location service is enabled on the device
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('[LocationController] Location services are disabled.');
        isLoading.value = false;
        return;
      }

      // 2. Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      // 3. If denied, request permission
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('[LocationController] Location permission denied by user.');
          permissionGranted.value = false;
          isLoading.value = false;
          return;
        }
      }

      // 4. If permanently denied, open app settings
      if (permission == LocationPermission.deniedForever) {
        debugPrint(
            '[LocationController] Location permission permanently denied. Opening settings...');
        permissionGranted.value = false;
        isLoading.value = false;
        await Geolocator.openAppSettings();
        return;
      }

      // 5. Permission granted — fetch location
      debugPrint('[LocationController] Permission granted. Fetching position...');
      permissionGranted.value = true;
      await _fetchCurrentLocation();
    } catch (e) {
      debugPrint('[LocationController] Error during permission request: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      print("Latitude: ${latitude.value}");
      print("Longitude: ${longitude.value}");

      debugPrint(
          '[LocationController] Position fetched — lat: ${position.latitude}, lng: ${position.longitude}');

      await _getAddressFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('[LocationController] Failed to fetch position: $e');
    }
  }

  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        city.value = place.locality ?? '';
        state.value = place.administrativeArea ?? '';
        print("City: ${city.value}");
        print("State: ${state.value}");

        debugPrint(
            '[LocationController] Address resolved — city: ${city.value}, state: ${state.value}');
      } else {
        debugPrint('[LocationController] No placemarks found for coordinates.');
      }
    } catch (e) {
      debugPrint('[LocationController] Reverse geocoding failed: $e');
    }
  }

  bool get hasLocation => latitude.value != 0.0 && longitude.value != 0.0;
}