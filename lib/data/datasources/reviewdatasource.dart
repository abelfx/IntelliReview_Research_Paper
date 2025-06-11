import 'package:dio/dio.dart';
import 'package:frontend/data/models/ReviewModel.dart';

class ReviewRemoteDataSource {
  final Dio dio;

  ReviewRemoteDataSource(this.dio);

  Future<void> createRating(
      String paperId, String? userId, String? rating, String comment) async {
    try {
      final response = await dio.post(
        'http://localhost:3500/api/review/CreateReview',
        data: {
          'paperId': paperId,
          'userId': userId,
          'rating': rating,
          'comment': comment,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 201) {
        print("Create review failed: ${response.data}");
        throw Exception('Failed to create review');
      }
    } catch (e) {
      throw Exception('Create review failed: $e');
    }
  }

  Future<List<ReviewModel>> getAllRating() async {
    try {
      final response = await dio.get(
        'http://localhost:3500/api/review/getallReview',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return data
              .map((item) => ReviewModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        } else {
          throw Exception('Unexpected response format. Expected a list.');
        }
      } else {
        print("Get reviews failed: ${response.data}");
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      throw Exception('Get reviews failed: $e');
    }
  }
}
