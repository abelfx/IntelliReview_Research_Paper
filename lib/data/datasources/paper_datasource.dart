// lib/data/datasources/paper_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paper_model.dart';

class PaperDataSource {
  final String baseApi = 'http://localhost:3500/api/paper/viewPapers';

  Future<PaperModel> uploadPaper({
    required String title,
    required List<String> authors,
    required int year,
    required String uploadedBy,
    required String category,
    required String filePath,
  }) async {
    final uri = Uri.parse('$baseApi/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['title'] = title
      ..fields['authors'] = authors.join(',')
      ..fields['year'] = year.toString()
      ..fields['uploadedBy'] = uploadedBy
      ..fields['category'] = category
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['paper'];
      return PaperModel.fromJson(data);
    } else {
      throw Exception('Upload failed: ${response.body}');
    }
  }

  Future<PaperModel> updatePaper({
    required String id,
    required String title,
    required List<String> authors,
    required int year,
    required String category,
    String? filePath,
  }) async {
    final uri = Uri.parse('$baseApi/update/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..fields['title'] = title
      ..fields['authors'] = authors.join(',')
      ..fields['year'] = year.toString()
      ..fields['category'] = category;

    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['paper'];
      return PaperModel.fromJson(data);
    } else {
      throw Exception('Update failed: ${response.body}');
    }
  }

  Future<List<PaperModel>> viewPapers() async {
    final response = await http.get(Uri.parse(baseApi));
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => PaperModel.fromJson(e)).toList();
    } else {
      throw Exception('Fetch failed: ${response.body}');
    }
  }

  Future<void> deletePaper(String id) async {
    final response = await http.delete(Uri.parse('$baseApi/$id'));
    if (response.statusCode != 200) {
      throw Exception('Delete failed: ${response.body}');
    }
  }
}
