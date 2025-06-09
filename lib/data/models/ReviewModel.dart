// lib/data/models/review_model.dart
import '../../domain/entities/Reviewentities.dart';

class ReviewModel extends Reviewentities {
  final String id;
  final String paperId;
  final String? userId;
  final String? rating;
  final String comment;

  ReviewModel({
    required this.id,
    required this.paperId,
    this.userId,
    this.rating,
    required this.comment,
  }) : super(
          id: id,
          paperId: paperId,
          userId: userId,
          rating: rating,
          comment: comment,
        );

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? json['id'] ?? '',
      paperId: json['paperId'] ?? '',
      userId: json['userId'],
      rating: json['rating'],
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paperId': paperId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
    };
  }
}
