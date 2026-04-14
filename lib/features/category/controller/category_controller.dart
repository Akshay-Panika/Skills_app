import 'package:get/get.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class CategoryController extends GetxController {
  var categoryList = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = "".obs; // ✅ ADD

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  Future<void> getCategories() async {
    try {
      isLoading(true);
      errorMessage(""); // ✅ reset

      final response = await CategoryRepository.getCategory();

      if (response != null && response.data != null) {
        categoryList.value = response.data!;
      } else {
        errorMessage("No categories found");
      }

    } catch (e) {
      errorMessage("Failed to load categories"); // ✅ set error
      print(e);
    } finally {
      isLoading(false);
    }
  }

  /// 🔁 Retry / Refresh
  Future<void> refreshCategories() async {
    await getCategories();
  }

  /// 💎 Helper getters (clean UI)
  bool get hasError => errorMessage.isNotEmpty;
  bool get isEmpty => categoryList.isEmpty && !isLoading.value;
}