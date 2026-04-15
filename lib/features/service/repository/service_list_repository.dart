import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../location/controller/location_controller.dart';
import '../model/service_list_model.dart';

class ServiceListRepository {
  final Dio _dio = ApiClient.dio;

  Future<ServiceListResponse> getServiceList() async {
    try {
      final LocationController locationController = Get.find();

      final userId = await AuthPreferences.getUserId();

      if (userId == null) {
        throw Exception("User not logged in");
      }

      final double lat = locationController.latitude.value;
      final double log = locationController.longitude.value;

      final response = await _dio.get(
        'service/list/',
        queryParameters: {
          'user': userId,
          'lat': lat,
          'lon': log,
        },
      );

      return ServiceListResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load service list: $e');
    }
  }
}