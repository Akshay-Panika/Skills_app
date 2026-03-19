import 'package:get/get.dart';
import '../repository/service_delete_repository.dart';

class ServiceDeleteController extends GetxController {
  final ServiceDeleteRepository repository = ServiceDeleteRepository();

  var isLoading = false.obs;
  var message = "".obs;

  Future<void> deleteService({required int userId, required int serviceId}) async {
    try {
      isLoading.value = true;
      String? responseMessage = await repository.deleteService(userId: userId, serviceId: serviceId);
      message.value = responseMessage ?? "Unknown error";
    } finally {
      isLoading.value = false;
    }
  }
}