import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

class ServiceDeleteRepository {
  final Dio _dio = ApiClient.dio;

  Future<String?> deleteService({required int userId, required int serviceId}) async {
    try {
      final response = await _dio.delete("service/user/$userId/delete/$serviceId/");
      if (response.statusCode == 200) {
        return response.data['message']; // "Service deleted successfully"
      } else {
        return "Failed to delete service";
      }
    } catch (e) {
      print("Delete Service Error: $e");
      return "Something went wrong";
    }
  }
}