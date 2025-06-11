import 'package:dio/dio.dart';
import '../models/paper_model.dart';

class PaperDataSource {
  final Dio dio;

  PaperDataSource(this.dio);

  final String baseViewApi = 'http://localhost:3500/api/paper/viewPapers';
  final String baseUploadApi = 'http://localhost:3500/api/paper/upload';
  final String baseUpdateApi = 'http://localhost:3500/api/paper/update';
  final String baseDeleteApi = 'http://localhost:3500/api/paper/delete';

  Future<PaperModel> uploadPaper({
    required String title,
    required List<String> authors,
    required int year,
    required String uploadedBy,
    required String category,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'authors': authors.join(','),
        'year': year.toString(),
        'uploadedBy': uploadedBy,
        'category': category,
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await dio.post(
        baseUploadApi,
        data: formData,
      );

      if (response.statusCode == 201) {
        final data = response.data['paper'];
        return PaperModel.fromJson(data);
      } else {
        throw Exception('Upload failed: ${response.data}');
      }
    } catch (e) {
      throw Exception('Upload failed: $e');
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
    try {
      final formData = FormData.fromMap({
        'title': title,
        'authors': authors.join(','),
        'year': year.toString(),
        'category': category,
        if (filePath != null)
          'file': await MultipartFile.fromFile(filePath),
      });

      final response = await dio.put(
        '$baseUpdateApi/$id',
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data['paper'];
        return PaperModel.fromJson(data);
      } else {
        throw Exception('Update failed: ${response.data}');
      }
    } catch (e) {
      throw Exception('Update failed: $e');
    }
  }

  Future<List<PaperModel>> viewPapers() async {
    try {
      final response = await dio.get(baseViewApi);

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => PaperModel.fromJson(e)).toList();
      } else {
        throw Exception('Fetch failed: ${response.data}');
      }
    } catch (e) {
      throw Exception('Fetch failed: $e');
    }
  }

  Future<void> deletePaper(String id) async {
    try {
      final response = await dio.delete('$baseDeleteApi/$id');
      if (response.statusCode != 200) {
        throw Exception('Delete failed: ${response.data}');
      }
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }
}
