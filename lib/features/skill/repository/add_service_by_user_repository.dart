import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
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
    required bool swipeStatus,
    required String imagePath,
    required double latitude,
    required double longitude,
  }) async {
    try {

      FormData formData = FormData.fromMap({
        "user": userId,
        "category": categoryId,
        "subcategory": subcategoryId,
        "service_name": name,
        "service_description": description,
        "service_amount": status ? amount : null,
        "service_status": status,
        "swipe_status": swipeStatus,
        "service_image": imagePath.isNotEmpty
            ? await MultipartFile.fromFile(imagePath)
            : null,
        // "service_image": await MultipartFile.fromFile(imagePath),
        "latitude": latitude,
        "longitude": longitude,
      });

      final response = await ApiClient.dio.post(
        "service/create/",
        data: formData,
      );

      return AddServiceByUserModel.fromJson(response.data);

    } catch (e) {
      throw Exception("Create Service Failed: $e");
    }
  }

  Future<AddServiceByUserModel> updateService({
    required int userId,
    required int serviceId,
    required int categoryId,
    required int subcategoryId,
    required String name,
    required String description,
    required String amount,
    required bool status,
    required bool swipeStatus,
    String? imagePath,
    required double latitude,
    required double longitude,
  }) async {
    try {

      Map<String, dynamic> map = {
        "user": userId,
        "category": categoryId,
        "subcategory": subcategoryId,
        "service_name": name,
        "service_description": description,
        "service_amount": status ? amount : null,
        "service_status": status,
        "swipe_status": swipeStatus,
        "latitude": latitude,
        "longitude": longitude,
      };

      // ✅ ONLY add image if new selected
      if (imagePath != null && imagePath.isNotEmpty) {
        map["service_image"] = await MultipartFile.fromFile(imagePath);
      }

      FormData formData = FormData.fromMap(map);

      final response = await ApiClient.dio.put(
        "service/user/$userId/update/$serviceId/",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      return AddServiceByUserModel.fromJson(response.data);

    } catch (e) {
      throw Exception("Update Service Failed: $e");
    }
  }
}