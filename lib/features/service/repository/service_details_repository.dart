import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../core/network/api_client.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../location/controller/location_controller.dart';
import '../model/service_details_model.dart';

class ServiceDetailsRepository {

  Future<ServiceDetailsModel> getServiceDetails(int id) async {
    try {

      final userId = AuthPreferences.getUserId();
      final locationController = Get.find<LocationController>();

      final lat = locationController.latitude.value;
      final lng = locationController.longitude.value;

      final response = await ApiClient.dio.get(
        'service/$id/',
        queryParameters: {
          "user": userId,
          "lat": lat,
          "lon": lng,
        },
      );

      return ServiceDetailsModel.fromJson(response.data);

    } catch (e) {
      throw Exception("Failed to load service details: $e");
    }
  }
}