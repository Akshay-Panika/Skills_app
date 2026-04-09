import 'package:dio/dio.dart';
import 'package:skills_app/core/network/api_client.dart';

class AuthRepository {

  static Future<Map<String, dynamic>> sendOtp(String phone) async {

    try {

      final response = await ApiClient.dio.post(
        "auth/send-otp/",
        data: {
          "user_phone": phone,
        },
      );

      return response.data;

    } on DioException catch (e) {


      print("Dio Error: ${e.message}");
      print("Type: ${e.type}");
      print("Response: ${e.response}");

      if (e.response != null) {
        return {
          "error": e.response?.data["message"] ?? "Server error"
        };
      }

      return {"error": "Network error"};

    } catch (e) {
      return {"error": "Something went wrong"};
    }

  }

  static Future<Map<String, dynamic>> verifyOtp(
      String phone,
      String otp,
      ) async {

    try {

      final response = await ApiClient.dio.post(
        "auth/verify-otp/",
        data: {
          "user_phone": phone,
          "otp": otp,
        },
      );

      return response.data;

    } on DioException catch (e) {

      if (e.response != null) {
        return {
          "error": e.response?.data["message"] ?? "Verification failed"
        };
      }

      return {"error": "Network error"};

    } catch (e) {
      return {"error": "Something went wrong"};
    }

  }

}