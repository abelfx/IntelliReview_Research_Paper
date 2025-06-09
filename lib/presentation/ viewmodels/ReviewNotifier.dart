import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/entities/Reviewentities.dart';
import 'package:frontend/domain/usecases/reviewusecase.dart';

class ReviewNotifier extends StateNotifier<AsyncValue<List<Reviewentities>>> {
  final RatingUseCase reviewUseCase;

  ReviewNotifier({required this.reviewUseCase}) : super(const AsyncValue.loading()) {
    loadReviews();
  }

  Future<void> loadReviews() async {
    state = const AsyncValue.loading();
    try {
      final reviews = await reviewUseCase.getallreview();
      state = AsyncValue.data(reviews);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createReview(
    String paperId,
    String? userId,
    String? rating,
    String comment,
  ) async {
    try {
      await reviewUseCase.createrating(paperId, userId, rating, comment);
      await loadReviews(); // Refresh the list after adding
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
