import 'package:get/get.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class CategoryController extends GetxController {
  var categoryList = <CategoryModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }
  Future<void> getCategories() async {
    try {
      isLoading(true);
      final response = await CategoryRepository.getCategory();
      if (response != null) {
        categoryList.value = response.data ?? [];
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}