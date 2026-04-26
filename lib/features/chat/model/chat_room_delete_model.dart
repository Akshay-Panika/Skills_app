class DeleteChatRoomResponse {
  final String message;

  DeleteChatRoomResponse({
    required this.message,
  });

  factory DeleteChatRoomResponse.fromJson(Map<String, dynamic> json) {
    return DeleteChatRoomResponse(
      message: json["message"] ?? "",
    );
  }
}
class DeleteChatRoomError {
  final String error;

  DeleteChatRoomError({
    required this.error,
  });

  factory DeleteChatRoomError.fromJson(Map<String, dynamic> json) {
    return DeleteChatRoomError(
      error: json["error"] ?? "",
    );
  }
}