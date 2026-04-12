import 'package:get/get.dart';
import '../../auth/helper/auth_preferences.dart';
import '../model/chat_model.dart';
import '../repository/chat_repository.dart';

class ChatController extends GetxController {

  final ChatRepository repository;

  ChatController(this.repository);

  var isLoading = false.obs;
  var chatList = <ChatModel>[].obs;

  int? userId;

  @override
  void onInit() {
    super.onInit();

    userId = AuthPreferences.getUserId();

    if (userId != null) {
      fetchChats(serviceId: Get.arguments["serviceId"]);
    } else {
      Get.snackbar("Error", "User not logged in");
    }
  }

  Future<void> fetchChats({
    required int serviceId,
  }) async {
    try {
      isLoading.value = true;

      final data = await repository.getChats(
        serviceId: serviceId,
        userId: userId!,
      );

      chatList.assignAll(data);

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}