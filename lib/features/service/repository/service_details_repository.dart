// servicedetails/repository/service_details_repository.dart
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../model/service_details_model.dart';

class ServiceDetailsRepository {
  Future<ServiceDetailsModel> getServiceById(int id) async {
    try {
      final Response response = await DioClient.dio.get('service/$id/');
      return ServiceDetailsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['detail'] ?? e.message);
    }
  }
}