import 'package:get/get.dart';
import 'package:skills_app/features/auth/controller/auth_controller.dart';

import '../../location/controller/location_controller.dart';

class AuthBinding extends Bindings{

  @override
  void dependencies(){
    Get.lazyPut(()=> LocationController(), fenix: true);
    Get.lazyPut(()=> AuthController(), fenix: true);
  }
}