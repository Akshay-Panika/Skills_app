import 'dart:io';

import 'package:get/get.dart';
import '../model/user_profile_model.dart';
import '../repository/user_profile_repository.dart';

class UserProfileController extends GetxController {

  var isLoading = false.obs;
  var userProfile = Rx<UserProfileModel?>(null);


  Future<void> fetchUserProfile(int userId) async {
    try {
      isLoading.value = true;
      userProfile.value = await UserProfileRepository.getUserProfile(userId);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(
      int profileId,
      UserProfileModel model, {
        File? imageFile,
      }) async {
    try {
      isLoading.value = true;

      final updated = await UserProfileRepository.updateUserProfile(
        profileId,
        model,
        imageFile: imageFile,
      );

      if (updated != null) {
        userProfile.value = updated;
      }
    } finally {
      isLoading.value = false;
    }
  }
}