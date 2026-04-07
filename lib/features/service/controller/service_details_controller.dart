// servicedetails/controller/service_details_controller.dart
import 'package:get/get.dart';
import '../model/service_details_model.dart';
import '../repository/service_details_repository.dart';

class ServiceDetailsController extends GetxController {
  final ServiceDetailsRepository _repository = ServiceDetailsRepository();

  final Rx<ServiceDetailsModel?> serviceDetails = Rx<ServiceDetailsModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchServiceDetails(int id) async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await _repository.getServiceById(id);
      serviceDetails(data);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}