import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../model/add_service_by_user_model.dart';

class AddServiceByUserRepository {

  Future<AddServiceByUserModel> createService({
    required int userId,
    required int categoryId,
    required int subcategoryId,
    required String name,
    required String description,
    required String amount,
    required bool status,
    required String imagePath,
  }) async {
    try {

      FormData formData = FormData.fromMap({
        "user": userId,
        "category": categoryId,
        "subcategory": subcategoryId,
        "service_name": name,
        "service_description": description,
        "service_amount": amount,
        "service_status": status,
        "service_image": await MultipartFile.fromFile(imagePath),
      });

      final response = await DioClient.dio.post(
        "service/create/",
        data: formData,
      );

      return AddServiceByUserModel.fromJson(response.data);

    } catch (e) {
      throw Exception("Create Service Failed: $e");
    }
  }
}