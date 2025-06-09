import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/%20viewmodels/ReviewNotifier.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/data/datasources/reviewdatasource.dart';
import 'package:frontend/data/repositories_impl/ReviewRepositoryimpl.dart';
import 'package:frontend/domain/usecases/reviewusecase.dart';
import 'package:frontend/domain/entities/Reviewentities.dart';


// HTTP Client
final httpClientProvider = Provider((ref) => http.Client());

// Data Source
final reviewRemoteDataSourceProvider = Provider((ref) {
  return ReviewRemoteDataSource(ref.watch(httpClientProvider));
});

// Repository
final reviewRepositoryProvider = Provider((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewRemoteDataSourceProvider));
});

// Use Case
final reviewUseCaseProvider = Provider((ref) {
  return RatingUseCase(ref.watch(reviewRepositoryProvider));
});

// StateNotifierProvider with List<Reviewentities>
final reviewNotifierProvider =
    StateNotifierProvider<ReviewNotifier, List<Reviewentities>>((ref) {
  return ReviewNotifier(reviewUseCase: ref.watch(reviewUseCaseProvider));
});
