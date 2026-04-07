import '../../../core/network/dio_client.dart';
import '../model/service_list_by_user_model.dart';

class ServiceListByUserRepository {
  Future<ServiceListByUserModel> getServicesByUser(int userId) async {
    try {
      final response = await DioClient.dio.get(
        "service/user/$userId/",
      );

      return ServiceListByUserModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    }
  }
}