import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../subcategory/controller/subategory_controller.dart';
import '../controller/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => SubCategoryController(), fenix: true);
  }
}