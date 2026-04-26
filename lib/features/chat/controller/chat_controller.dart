import 'package:get/get.dart';
import '../model/chat_message_model.dart';
import '../model/chat_room_list_model.dart';
import '../repository/chat_repository.dart';
import '../../auth/helper/auth_preferences.dart';

class ChatController extends GetxController {

  var isLoading = false.obs;
  var isMessageLoading = false.obs;
  var isCreateRoomLoading = false.obs;

  var roomList = <ChatRoomListModel>[].obs;
  var messageList = <ChatMessageModel>[].obs;

  int? currentUserId;

  @override
  void onInit() {
    super.onInit();
    currentUserId = AuthPreferences.getUserId();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    isLoading.value = true;

    final result = await ChatRepository.getRooms();
    roomList.assignAll(result);

    isLoading.value = false;
  }

  Future<void> fetchMessages(int roomId) async {
    messageList.clear();
    isMessageLoading.value = true;

    final result = await ChatRepository.getHistory(roomId);

    if (result != null) {
      messageList.assignAll(result.messages);
    } else {
      messageList.clear();
    }

    isMessageLoading.value = false;
  }

  Future<void> createRoom({
    required int serviceId,
    required int buyerId,
    String? message,
  }) async {
    isCreateRoomLoading.value = true;

    try {
      final result = await ChatRepository.createRoom(
        serviceId: serviceId,
        buyerId: buyerId,
        message: message,
      );

      if (result != null) {
        await fetchRooms();
      }
    } catch (e) {
      print("Create Room Error: $e");
    } finally {
      isCreateRoomLoading.value = false;
    }
  }


  Future<void> deleteRooms(List<int> roomIds) async {
    try {
      roomList.removeWhere((e) => roomIds.contains(e.roomId));
      roomList.refresh();

      final result = await ChatRepository.bulkDelete(roomIds);

      if (result != "deleted") {
        await fetchRooms();
      }

    } catch (e) {
      print("Delete Error: $e");
      await fetchRooms();
    }
  }}
