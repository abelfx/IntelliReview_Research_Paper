import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/paper_datasource.dart';
import '../../data/repositories_impl/paper_repository_impl.dart';
import '../../domain/usecases/paper_usecase.dart';
import "../../presentation/ viewmodels/PaperNotifier.dart";

/// Provides the data source for fetching papers
final paperDataSourceProvider =
    Provider<PaperDataSource>((ref) => PaperDataSource());

/// Provides the repository implementation using the data source
final paperRepositoryProvider = Provider<PaperRepositoryImpl>((ref) {
  final dataSource = ref.watch(paperDataSourceProvider);
  return PaperRepositoryImpl(dataSource: dataSource);
});

/// Provides the use case that orchestrates repository calls
final paperUseCaseProvider = Provider<PaperUseCase>((ref) {
  final repository = ref.watch(paperRepositoryProvider);
  return PaperUseCase(repository: repository);
});

/// Provides the PaperNotifier (StateNotifier) and exposes its state
final paperNotifierProvider = StateNotifierProvider<PaperNotifier, PaperState>(
  (ref) {
    final useCase = ref.watch(paperUseCaseProvider);
    return PaperNotifier(useCase);
  },
);
