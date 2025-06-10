// lib/data/datasources/review_remote_data_source.dart
import 'dart:convert';

import 'package:frontend/data/models/ReviewModel.dart';
import 'package:http/http.dart' as http;

class ReviewRemoteDataSource {
  final http.Client client;

  ReviewRemoteDataSource(this.client);

  Future<void> createRating(
      String paperId, String? userId, String? rating, String comment) async {
    final body = jsonEncode({
      'paperId': paperId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
    });

    final response = await client.post(
      Uri.parse('http://localhost:3500/api/review/CreateReview'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 201) {
      // Print actual error for debugging
      print("Create review failed: ${response.body}");
      throw Exception('Failed to create review');
    }
  }

  Future<List<ReviewModel>> getAllRating() async {
  final response = await client.get(
    Uri.parse('http://localhost:3500/api/review/getallReview'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data is List) {
      return data
          .map((item) => ReviewModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else {
      throw Exception('Unexpected response format. Expected a list.');
    }
  } else {
    print("Get reviews failed: ${response.body}");
    throw Exception('Failed to load reviews');
  }
}

}
