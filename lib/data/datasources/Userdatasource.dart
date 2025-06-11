import 'package:dio/dio.dart';

class UserDataSource {
  final Dio dio;
  final String baseApi = "http://localhost:3500/api/auth";

  UserDataSource(this.dio);

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String country,
    required String role,
  }) async {
    try {
      final response = await dio.post(
        '$baseApi/signup',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'country': country,
          'role': role,
        },
      );

      print("Signup successful: ${response.data['user']['name']}");
      return response.data;
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? e.message;
      print("Signup failed: $error");
      throw Exception("Signup failed: $error");
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '$baseApi/login',
        data: {'email': email, 'password': password},
      );

      print("Login successful. Welcome ${response.data['user']['name']}");
      return response.data;
    } on DioException catch (e) {
      final error = e.response?.data['message'] ?? e.response?.data['error'] ?? e.message;
      print("Login failed: $error");
      throw Exception("Login failed: $error");
    }
  }

  Future<void> logout() async {
    try {
      final response = await dio.post('$baseApi/logout');

      if (response.statusCode == 201) {
        print("Logout successful");
      } else {
        final error = response.data['message'] ?? response.data['error'];
        throw Exception("Logout failed: $error");
      }
    } on DioException catch (e) {
      final error = e.response?.data['message'] ?? e.response?.data['error'] ?? e.message;
      print("Logout failed: $error");
      throw Exception("Logout failed: $error");
    }
  }
}
