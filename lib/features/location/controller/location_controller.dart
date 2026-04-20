// import 'package:flutter/foundation.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
//
// class LocationController extends GetxController {
//   var latitude = 0.0.obs;
//   var longitude = 0.0.obs;
//   var city = ''.obs;
//   var state = ''.obs;
//   var isLoading = false.obs;
//   var permissionGranted = false.obs;
//
//   Future<void> requestLocationPermission() async {
//     isLoading.value = true;
//
//     try {
//       // 1. Check if location service is enabled on the device
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         debugPrint('[LocationController] Location services are disabled.');
//         isLoading.value = false;
//         return;
//       }
//
//       // 2. Check current permission status
//       LocationPermission permission = await Geolocator.checkPermission();
//
//       // 3. If denied, request permission
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           debugPrint('[LocationController] Location permission denied by user.');
//           permissionGranted.value = false;
//           isLoading.value = false;
//           return;
//         }
//       }
//
//       // 4. If permanently denied, open app settings
//       if (permission == LocationPermission.deniedForever) {
//         debugPrint(
//             '[LocationController] Location permission permanently denied. Opening settings...');
//         permissionGranted.value = false;
//         isLoading.value = false;
//         await Geolocator.openAppSettings();
//         return;
//       }
//
//       // 5. Permission granted — fetch location
//       debugPrint('[LocationController] Permission granted. Fetching position...');
//       permissionGranted.value = true;
//       await _fetchCurrentLocation();
//     } catch (e) {
//       debugPrint('[LocationController] Error during permission request: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> _fetchCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       latitude.value = position.latitude;
//       longitude.value = position.longitude;
//       print("Latitude: ${latitude.value}");
//       print("Longitude: ${longitude.value}");
//
//       debugPrint(
//           '[LocationController] Position fetched — lat: ${position.latitude}, lng: ${position.longitude}');
//
//       await _getAddressFromCoordinates(position.latitude, position.longitude);
//     } catch (e) {
//       debugPrint('[LocationController] Failed to fetch position: $e');
//     }
//   }
//
//   Future<void> _getAddressFromCoordinates(double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//
//         city.value = place.locality ?? '';
//         state.value = place.administrativeArea ?? '';
//         print("City: ${city.value}");
//         print("State: ${state.value}");
//
//         debugPrint(
//             '[LocationController] Address resolved — city: ${city.value}, state: ${state.value}');
//       } else {
//         debugPrint('[LocationController] No placemarks found for coordinates.');
//       }
//     } catch (e) {
//       debugPrint('[LocationController] Reverse geocoding failed: $e');
//     }
//   }
//
//   bool get hasLocation => latitude.value != 0.0 && longitude.value != 0.0;
// }

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/controller/service_list_controller.dart';
import '../../skill/controller/service_list_by_user_controller.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var city = ''.obs;
  var state = ''.obs;
  var isLoading = false.obs;
  var permissionGranted = false.obs;
  var isLocationLoaded = false.obs;

  // Keys
  static const _keyLat = 'loc_lat';
  static const _keyLng = 'loc_lng';
  static const _keyCity = 'loc_city';
  static const _keyState = 'loc_state';

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocation(); // ✅ Load on startup
  }

  /// Load persisted location when controller initializes
  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    latitude.value  = prefs.getDouble(_keyLat)  ?? 0.0;
    longitude.value = prefs.getDouble(_keyLng)  ?? 0.0;
    city.value      = prefs.getString(_keyCity) ?? '';
    state.value     = prefs.getString(_keyState) ?? '';
    isLocationLoaded.value = true;
    debugPrint('[LocationController] Loaded saved location — '
        'city: ${city.value}, state: ${state.value}');
  }

  /// Save location to SharedPreferences
  Future<void> _saveLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyLat,  latitude.value);
    await prefs.setDouble(_keyLng,  longitude.value);
    await prefs.setString(_keyCity, city.value);
    await prefs.setString(_keyState, state.value);
  }

  Future<void> requestLocationPermission() async {
    isLoading.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLoading.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          permissionGranted.value = false;
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        permissionGranted.value = false;
        isLoading.value = false;
        await Geolocator.openAppSettings();
        return;
      }

      permissionGranted.value = true;
      await _fetchCurrentLocation();
    } catch (e) {
      debugPrint('[LocationController] Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value  = position.latitude;
      longitude.value = position.longitude;
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
        city.value  = place.locality ?? '';
        state.value = place.administrativeArea ?? '';
        await _saveLocation(); // ✅ Persist after resolving address
        debugPrint('[LocationController] Saved — city: ${city.value}, state: ${state.value}');
      }
    } catch (e) {
      debugPrint('[LocationController] Reverse geocoding failed: $e');
    }
  }

  /// Map se manually selected spot update karna
  Future<void> updateFromMapSelection(double lat, double lng) async {
    latitude.value  = lat;
    longitude.value = lng;
    await _getAddressFromCoordinates(lat, lng);
  }

  /// Current GPS location fetch karo (map ke liye)
  Future<LatLng?> getCurrentLatLng() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      Get.find<ServiceListController>().fetchServiceList();
      return LatLng(position.latitude, position.longitude);

    } catch (e) {
      debugPrint('[LocationController] getCurrentLatLng failed: $e');
      return null;
    }
  }

  bool get hasLocation => latitude.value != 0.0 && longitude.value != 0.0;
}