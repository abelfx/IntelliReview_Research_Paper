import 'package:dio/dio.dart';
import 'package:frontend/data/models/Categorymodel.dart';
import 'package:frontend/domain/entities/Categoryentities.dart';

class CategoryDataSource {
  final String baseApi = "http://localhost:3500/api/category";
  final Dio _dio = Dio();

  Future<List<Categoryentities>> getAllCategory() async {
    try {
      final response = await _dio.get("$baseApi/getallCategory");
      if (response.statusCode == 200) {
        final List data = response.data;
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
      final response = await _dio.post(
        "$baseApi/createCategory",
        data: {
          'name': name,
          'description': description,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );
      if (response.statusCode == 201) {
        print("Created successfully");
      } else {
        throw Exception("Failed to create category");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> deleteCategory(String id) async {
    if (id.trim().isEmpty) {
      throw Exception("Invalid ID: Cannot delete category with empty ID");
    }

    try {
      final response = await _dio.delete("$baseApi/deleteCategory/${id.trim()}");
      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Deleted successfully");
      } else {
        throw Exception("Failed to delete category. Status code: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Delete request failed: $error");
    }
  }

  Future<Categoryentities> updateCategory(String id, String name, String description) async {
    try {
      final response = await _dio.put(
        "$baseApi/updateCategory/$id",
        data: {
          'name': name,
          'description': description,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        return Categorymodel.fromjson(response.data);
      } else {
        throw Exception("Failed to update category");
      }
    } catch (error) {
      rethrow;
    }
  }
}
