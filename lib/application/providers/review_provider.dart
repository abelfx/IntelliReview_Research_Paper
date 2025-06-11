import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:frontend/data/datasources/reviewdatasource.dart';
import 'package:frontend/presentation/%20viewmodels/ReviewNotifier.dart';
import 'package:frontend/data/repositories_impl/ReviewRepositoryimpl.dart';
import 'package:frontend/domain/usecases/reviewusecase.dart';
import 'package:frontend/domain/entities/Reviewentities.dart';

/// 1. Dio Client Provider
final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  );
  return dio;
});

/// 2. Data Source with Dio
final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return ReviewRemoteDataSource(dio);
});

/// 3. Repository
final reviewRepositoryProvider = Provider<ReviewRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(reviewRemoteDataSourceProvider);
  return ReviewRepositoryImpl(remoteDataSource);
});

/// 4. Use Case
final reviewUseCaseProvider = Provider<RatingUseCase>((ref) {
  final repository = ref.watch(reviewRepositoryProvider);
  return RatingUseCase(repository);
});

/// 5. StateNotifier
final reviewNotifierProvider = StateNotifierProvider<ReviewNotifier, AsyncValue<List<Reviewentities>>>((ref) {
  final useCase = ref.watch(reviewUseCaseProvider);
  return ReviewNotifier(reviewUseCase: useCase);
});
