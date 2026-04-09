import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:skills_app/core/network/api_client.dart';
import 'package:skills_app/features/account/model/user_profile_model.dart';

class UserProfileRepository {

  static Future<UserProfileModel?> getUserProfile(int userId) async {
    try {
      final response = await ApiClient.dio.get("profiles/$userId/");

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


  static Future<UserProfileModel?> updateUserProfile(
      int userId,
      UserProfileModel model, {
        File? imageFile,
      }) async {
    try {

      FormData formData = FormData.fromMap({
        "user_name": model.userName,
        "user_email": model.userEmail,
        "user_gender": model.userGender,
        "user_bio": model.userBio,

        // ✅ IMAGE (only if selected)
        if (imageFile != null)
          "user_image": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await ApiClient.dio.put(
        "profiles/$userId/",
        data: formData, // ✅ IMPORTANT
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data);
      }

      return null;

    } on DioException catch (e) {
      debugPrint("Update Error: ${e.message}");
      return null;
    }
  }

}