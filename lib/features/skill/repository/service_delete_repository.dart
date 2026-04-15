import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class ServiceDeleteRepository {
  final Dio _dio = ApiClient.dio;

  Future<String> deleteService({
    required int userId,
    required int serviceId,
  }) async {
    try {
      final response = await _dio.delete(
        "service/user/$userId/delete/$serviceId/",
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.data?['message'] ?? "Service deleted successfully";
      }

      return "Failed to delete service";
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data["error"] ?? "Delete failed";
      }
      return "Network error";
    } catch (e) {
      return "Something went wrong";
    }
  }
}