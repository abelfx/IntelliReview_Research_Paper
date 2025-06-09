// lib/data/datasources/review_remote_data_source.dart
import 'dart:convert';
import 'package:frontend/data/models/ReviewModel.dart';
import 'package:http/http.dart' as http;


class ReviewRemoteDataSource {
  final http.Client client;

  ReviewRemoteDataSource(this.client);

  Future<void> createRating(String paperId, String? userId, String? rating, String comment) async {
    final response = await client.post(
      Uri.parse('http://localhost:3500/api/reviews/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'paperId': paperId,
        'userId': userId,
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create review');
    }
  }

  Future<List<ReviewModel>> getAllRating() async {
    final response = await client.get(
      Uri.parse('http://localhost:3500/api/reviews'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ReviewModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
