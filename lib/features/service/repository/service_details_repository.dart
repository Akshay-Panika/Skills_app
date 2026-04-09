import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/service_details_model.dart';

class ServiceDetailsRepository {
  Future<ServiceDetailsModel> getServiceDetails(int id) async {
    try {
      final response = await ApiClient.dio.get('service/$id/');

      if (response.statusCode == 200 && response.data != null) {
        return ServiceDetailsModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // 🔥 safe error handling
      return Future.error(
        e.response?.data?['message'] ?? 'Server error',
      );
    } catch (_) {
      return Future.error('Something went wrong');
    }
  }
}