import 'package:dio/dio.dart';

class ApiClient {

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://skills-app-service.onrender.com/api/",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

}