import 'package:get/get.dart';
import '../model/service_details_model.dart';
import '../repository/service_details_repository.dart';

class ServiceDetailsController extends GetxController {
  final _repository = ServiceDetailsRepository();

  final serviceDetails = Rx<ServiceDetailsModel?>(null);
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> fetchServiceDetails(int serviceId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      serviceDetails.value = await _repository.getServiceDetails(serviceId);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}