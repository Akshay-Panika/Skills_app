import 'package:get/get.dart';

import '../model/subcategory_model.dart';
import '../repository/subcategory_repository.dart';

class SubCategoryController extends GetxController {
  final SubCategoryRepository repository = SubCategoryRepository();


  var subCategories = <SubCategory>[].obs;
  var isLoading = false.obs;
  var categoryName = ''.obs;
  var count = 0.obs;

  // Fetch subcategories for a category id
  Future<void>  fetchSubCategories(int categoryId) async {
    try {
      isLoading.value = true;
      SubCategoryResponse response =
      await repository.getSubCategoriesByCategoryId(categoryId);

      subCategories.value = response.data;
      categoryName.value = response.category;
      count.value = response.count;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}