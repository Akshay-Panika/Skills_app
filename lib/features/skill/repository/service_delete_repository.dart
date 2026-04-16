import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class ServiceDeleteRepository {
  final Dio _dio = ApiClient.dio;

  Future<String> deleteService({
    required int userId,
    required List<int> serviceIds,
  }) async {
    try {
      final response = await _dio.post(
        "service/user/$userId/bulk-delete/",
        data: {
          "ids": serviceIds,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data["message"] ?? "Deleted successfully";
      }

      return "Failed to delete service";
    } on DioException catch (e) {
      return e.response?.data["error"] ?? "Delete failed";
    } catch (e) {
      return "Something went wrong";
    }
  }
}