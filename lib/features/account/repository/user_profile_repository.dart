import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:skills_app/core/network/dio_client.dart';
import 'package:skills_app/features/account/model/user_profile_model.dart';

class UserProfileRepository {

  static Future<UserProfileModel?> getUserProfile(int userId) async {
    try {
      final response = await DioClient.dio.get("profiles/$userId/");

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data);
      }

      return null;

    } on DioException catch (e) {
      debugPrint("Profile Error: ${e.message}");
      return null; // null return on error
    } catch (e) {
      debugPrint("Unknown Error: $e");
      return null;
    }
  }
}