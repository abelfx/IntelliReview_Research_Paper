import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:frontend/presentation/%20viewmodels/PaperNotifier.dart';

import '../../data/datasources/paper_datasource.dart';
import '../../data/repositories_impl/paper_repository_impl.dart';
import '../../domain/usecases/paper_usecase.dart';


/// 1. Dio Client Provider
final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  return dio;
});

/// 2. Provides the data source for fetching papers
final paperDataSourceProvider = Provider<PaperDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return PaperDataSource(dio);
});

/// 3. Provides the repository implementation using the data source
final paperRepositoryProvider = Provider<PaperRepositoryImpl>((ref) {
  final dataSource = ref.watch(paperDataSourceProvider);
  return PaperRepositoryImpl(dataSource: dataSource);
});

/// 4. Provides the use case that orchestrates repository calls
final paperUseCaseProvider = Provider<PaperUseCase>((ref) {
  final repository = ref.watch(paperRepositoryProvider);
  return PaperUseCase(repository: repository);
});

/// 5. Provides the PaperNotifier (StateNotifier) and exposes its state
final paperNotifierProvider = StateNotifierProvider<PaperNotifier, PaperState>(
  (ref) {
    final useCase = ref.watch(paperUseCaseProvider);
    return PaperNotifier(useCase);
  },
);
