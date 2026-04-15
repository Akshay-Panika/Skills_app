import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';


class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var city = ''.obs;
  var state = ''.obs;
  var isLocationLoaded = false.obs;

  /// Call this to fetch current location
  Future<void> fetchLocation() async {
    try {
      // Show loading
      isLocationLoaded.value = false;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Location permission denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Get city & state
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude.value, longitude.value);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        city.value = place.locality ?? '';
        state.value = place.administrativeArea ?? '';
      }

      // Finished loading
      isLocationLoaded.value = true;

      print("Location fetched: ${latitude.value}, ${longitude.value}");
      print("City: ${city.value}, State: ${state.value}");
    } catch (e) {
      print("Error fetching location: $e");
      isLocationLoaded.value = true; // Stop loading on error
    }
  }
}