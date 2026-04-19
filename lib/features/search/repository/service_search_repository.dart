import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../location/controller/location_controller.dart';
import '../model/service_search_model.dart';

class ServiceSearchRepository {
  final Dio _dio = ApiClient.dio;

  final LocationController _locationController =
  Get.find<LocationController>();

  Future<ServiceSearchModel> getSearchedServices({
    required String query,
  }) async {
    try {
      final userId = await AuthPreferences.getUserId();

      if (userId == null) {
        throw Exception("User not logged in");
      }

      final double lat = _locationController.latitude.value;
      final double lon = _locationController.longitude.value;

      final response = await _dio.get(
        'service/search/',
        queryParameters: {
          'user': userId,
          'lat': lat,
          'lon': lon,
          'query': query,
        },
      );

      return ServiceSearchModel.fromJson(response.data);
    } catch (e) {
      throw Exception(
        'Failed to load searched services: $e',
      );
    }
  }
}