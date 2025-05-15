import 'dart:convert';
import 'package:frontend/data/models/Categorymodel.dart';
import 'package:frontend/domain/entities/Categoryentities.dart';
import 'package:http/http.dart' as http;

class CategoryDataSource {
  final String baseApi = "http://localhost:3500/api/category";


  Future<List<Categoryentities>> getAllCategory() async {
    try {
      final response = await http.get(Uri.parse(baseApi));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Categorymodel.fromjson(json)).toList();
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (error) {
      rethrow;
    }
  }


  Future<void> createCategory(String name, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseApi/createCategory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
        }),
      );
      if (response.statusCode == 201) {
        print("Created successfully");
      } else {
        throw Exception("Failed to create category");
      }
    } catch (error) {
      print(error);
    }
  }


  Future<void> deleteCategory(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseApi/$id'));
      if (response.statusCode == 200) {
        print("Deleted successfully");
      } else {
        throw Exception("Failed to delete category");
      }
    } catch (error) {
      print(error);
    }
  }

  
  Future<Categoryentities> updateCategory(
      String id, String name, String description) async {
    try {
      final response = await http.put(
        Uri.parse('$baseApi/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return Categorymodel.fromjson(jsonBody);
      } else {
        throw Exception("Failed to update category");
      }
    } catch (error) {
      rethrow;
    }
  }
}
