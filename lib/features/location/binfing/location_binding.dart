import 'package:get/get.dart';
import 'package:skills_app/features/location/controller/location_controller.dart';

class LocationBinding extends Bindings{

  @override
  void dependencies(){
    Get.lazyPut(()=> LocationController(), fenix: true);
  }
}