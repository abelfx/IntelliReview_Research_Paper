// lib/data/repositories/review_repository_impl.dart
import 'package:frontend/data/datasources/reviewdatasource.dart';
import 'package:frontend/domain/entities/Reviewentities.dart';
import 'package:frontend/domain/repositories/reviewrepositories.dart';

class ReviewRepositoryImpl implements Reviewrepositories {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createRating(String paperId, String? userId, String? rating, String comment) {
    return remoteDataSource.createRating(paperId, userId, rating, comment);
  }

  @override
  Future<List<Reviewentities>> getallRating() async {
    return await remoteDataSource.getAllRating();
  }
}
