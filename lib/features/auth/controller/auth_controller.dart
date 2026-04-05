import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';
import '../helper/auth_preferences.dart';
import '../repository/auth_repository.dart';

class AuthController extends GetxController {

  var loading = false.obs;
  var isOtpSent = false.obs;
  var resendSeconds = 30.obs;

  /// phone validation
  bool isValidPhone(String phone) {
    final regex = RegExp(r'^\+91[6-9]\d{9}$');
    return regex.hasMatch(phone);
  }

  /// otp validation
  bool isValidOtp(String otp) {
    final regex = RegExp(r'^[0-9]{6}$');
    return regex.hasMatch(otp);
  }

  Future<void> sendOtp(String phone) async {

    if (!isValidPhone(phone)) {
      FlutterToast.error("Enter valid phone number");
      return;
    }

    loading.value = true;

    final res = await AuthRepository.sendOtp(phone);

    loading.value = false;

    if (res["message"] == "OTP sent successfully") {

      isOtpSent.value = true;

      startTimer();

      FlutterToast.success("OTP Sent Successfully");

    } else {

      FlutterToast.error(res["error"] ?? "Failed to send OTP");

    }

  }

  Future<bool> verifyOtp(String phone, String otp) async {

    if (!isValidOtp(otp)) {
      FlutterToast.error(
          "Enter valid 6 digit OTP"
      );
      return false;
    }

    loading.value = true;

    final res = await AuthRepository.verifyOtp(phone, otp);

    loading.value = false;

    if (res["message"] == "Phone verified") {

      /// id extract
      int userId = res["data"]["id"];
      await AuthPreferences.setLogin(userId);

      FlutterToast.success("Login Successful");

      return true;

    } else {

      FlutterToast.error(
          res["error"] ?? "OTP verification failed"
      );

      return false;

    }

  }

  void startTimer() {

    resendSeconds.value = 30;

    Future.doWhile(() async {

      await Future.delayed(const Duration(seconds: 1));

      if (resendSeconds.value == 0) return false;

      resendSeconds.value--;

      return true;

    });

  }

  void resetAuth() {
    isOtpSent.value = false;
    resendSeconds.value = 30;
  }

}