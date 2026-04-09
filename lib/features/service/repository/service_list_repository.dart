import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../model/service_list_model.dart';

class ServiceListRepository {
  final Dio _dio = ApiClient.dio;

  Future<ServiceListResponse> getServiceList() async {
    try {
      final response = await _dio.get('service/list/');
      return ServiceListResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load service list: $e');
    }
  }
}