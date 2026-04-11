import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

class WishlistRemoveRepository {

  Future<Map<String, dynamic>> removeFavorite({
    required int userId,
    required int serviceId,
  }) async {
    try {
      final response = await ApiClient.dio.delete(
        "favorite/remove/$userId/$serviceId/",
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data ?? "Something went wrong while removing favorite",
      );
    }
  }
}