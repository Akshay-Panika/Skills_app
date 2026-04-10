import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/wishlist_toggle_model.dart';
import '../model/wishlist_toggle_responce_model.dart';

class WishlistToggleRepository {

  Future<WishlistToggleResponseModel> toggleWishlist(
      WishlistToggleModel request) async {

    try {
      final response = await ApiClient.dio.post(
        "favorite/toggle/",
        data: request.toJson(),
      );

      final data = response.data;

      /// 🔥 SAFE CHECK
      if (data is String) {
        return WishlistToggleResponseModel.fromJson(
          jsonDecode(data),
        );
      }

      return WishlistToggleResponseModel.fromJson(
        Map<String, dynamic>.from(data),
      );

    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? "API Error",
      );
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}