
import 'package:get/get.dart';

import '../controller/wishlist_controller.dart';
import '../controller/wishlist_remove_controller.dart';

class WishlistBinding extends Bindings{

  @override
  void dependencies(){
    Get.lazyPut<WishlistController>(()=> WishlistController(),fenix: true);
    Get.lazyPut<WishlistRemoveController>(()=> WishlistRemoveController(),fenix: true);
  }
}