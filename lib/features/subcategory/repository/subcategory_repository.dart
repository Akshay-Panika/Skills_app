import '../../../core/network/dio_client.dart';
import '../model/subcategory_model.dart';

class SubCategoryRepository {
  Future<SubCategoryResponse> getSubCategoriesByCategoryId(int categoryId) async {
    try {
      final response = await DioClient.dio.get("subcategory/$categoryId/");

      if (response.statusCode == 200) {
        return SubCategoryResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to load subcategories");
      }
    } catch (e) {
      print("Error fetching subcategories: $e");
      rethrow;
    }
  }
}