import 'package:get/get.dart';
import 'package:skills_app/features/auth/controller/auth_controller.dart';

class AuthBinding extends Bindings{

  @override
  void dependencies(){
    Get.lazyPut(()=> AuthController(), fenix: true);
  }
}