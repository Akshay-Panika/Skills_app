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
}