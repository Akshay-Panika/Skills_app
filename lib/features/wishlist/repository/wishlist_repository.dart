import 'package:dio/dio.dart';
import 'package:skills_app/features/wishlist/model/wishlist_model.dart';
import '../../../core/network/api_client.dart';
import '../../../features/auth/helper/auth_preferences.dart';

class WishlistRepository {
  final Dio _dio = ApiClient.dio;

  Future<WishlistResponse> getWishlist() async {
    try {
      // ✅ Get userId from SharedPreferences
      final userId = await AuthPreferences.getUserId();

      if (userId == null) {
        throw Exception("User not logged in");
      }

      // ✅ Dynamic API call
      final response = await _dio.get('favorite/user/$userId/');

      return WishlistResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load wishlist: $e');
    }
  }
}