import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/entities/Reviewentities.dart';
import 'package:frontend/domain/usecases/reviewusecase.dart';

class ReviewNotifier extends StateNotifier<List<Reviewentities>> {
  final RatingUseCase reviewUseCase;

  ReviewNotifier({required this.reviewUseCase}) : super([]);

  Future<void> loadReviews() async {
    try {
      final reviews = await reviewUseCase.getallreview();
      state = reviews;
    } catch (e) {
      // handle error as needed (e.g. logging)
      state = []; // fallback to empty
    }
  }

  Future<void> createReview(
      String paperId, String? userId, String? rating, String comment) async {
    try {
      await reviewUseCase.createrating(paperId, userId, rating, comment);
      await loadReviews();
    } catch (e) {
      // handle error as needed
    }
  }
}
