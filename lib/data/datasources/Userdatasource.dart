import 'dart:convert';
import 'package:http/http.dart' as http;

class UserDataSource {
  final String baseApi = "http://localhost:3500/api/auth";

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String country,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseApi/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'country': country,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Signup successful: ${data['user']['name']}");
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Signup failed: ${error['error']}");
      }
    } catch (error) {
      print("Error during signup: $error");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseApi/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Login successful. Welcome ${data['user']['name']}");
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Login failed: ${error['message'] ?? error['error']}");
      }
    } catch (error) {
      print("Error during login: $error");
      rethrow;
    }
  }
   Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseApi/logouut'),
  
   );

      if (response.statusCode == 201) {

        print("Logout successfully");
      
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Logout failed: ${error['message'] ?? error['error']}");
      }
    } catch (error) {
      print("Error during logout: $error");
      rethrow;
    }
  }
}
