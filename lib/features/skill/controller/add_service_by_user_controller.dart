import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';
import 'package:skills_app/features/skill/controller/service_list_by_user_controller.dart';
import '../../auth/helper/auth_preferences.dart';
import '../../chat/controller/booking_controller.dart';
import '../../service/controller/service_list_controller.dart';
import '../repository/add_service_by_user_repository.dart';

class AddServiceByUserController extends GetxController {

  final AddServiceByUserRepository repository = AddServiceByUserRepository();


  var isLoading = false.obs;

  Future<void> createService({
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
      isLoading.value = true;

      final userId = await AuthPreferences.getUserId();

      if (userId == null) {
        FlutterToast.error("User not logged in");
        isLoading.value = false;
        return;
      }

      final data = await repository.createService(
        userId: userId,
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        name: name,
        description: description,
        amount: amount,
        status: status,
        swipeStatus: swipeStatus,
        imagePath: imagePath,
        latitude: latitude,
        longitude: longitude,
      );

      FlutterToast.success("Service Created Successfully");
      Get.find<ServiceListController>().fetchServiceList();
      Get.find<ServiceListByUserController>().fetchMyServices();
      Get.find<BookingController>().fetchBookings();

    } on DioException catch (e) {
      FlutterToast.error(e.response?.data.toString() ?? "Server Error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateService({
    required int serviceId,
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
      isLoading.value = true;

      final userId = await AuthPreferences.getUserId();

      if (userId == null) {
        FlutterToast.error("User not logged in");
        isLoading.value = false;
        return;
      }

      final finalAmount = status ? amount : "";

      final data = await repository.updateService(
        userId: userId,
        serviceId: serviceId,
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        name: name,
        description: description,
        amount: finalAmount,
        status: status,
        swipeStatus: swipeStatus,
        imagePath: imagePath,
        latitude: latitude,
        longitude: longitude,
      );

      FlutterToast.success("Service Updated Successfully");

      Get.find<ServiceListController>().fetchServiceList();
      Get.find<ServiceListByUserController>().fetchMyServices();
      Get.find<BookingController>().fetchBookings();

    }  on DioException catch (e) {
      FlutterToast.error(e.response?.data.toString() ?? "Server Error");
    } finally {
      isLoading.value = false;
    }
  }
}