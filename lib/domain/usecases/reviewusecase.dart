// lib/domain/usecases/create_rating_usecase.dart
import 'package:frontend/domain/entities/Reviewentities.dart';

import '../repositories/reviewrepositories.dart';

class RatingUseCase {
  final Reviewrepositories repository;

      RatingUseCase(this.repository);

  Future<void> createrating(String paperId, String? userId, String? rating, String comment) {
    return repository.createRating(paperId, userId, rating, comment);
  }


  

  Future<List<Reviewentities>> getallreview() {
    return repository.getallRating();
  }

}
