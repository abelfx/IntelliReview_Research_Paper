import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/paper_datasource.dart';
import '../../data/repositories_impl/paper_repository_impl.dart';
import '../../domain/usecases/paper_usecase.dart';
import "../../presentation/ viewmodels/PaperNotifier.dart";

final paperDataSourceProvider =
    Provider<PaperDataSource>((ref) => PaperDataSource());

final paperRepositoryProvider = Provider<PaperRepositoryImpl>((ref) {
  final ds = ref.watch(paperDataSourceProvider);
  return PaperRepositoryImpl(dataSource: ds);
});

final paperUseCaseProvider = Provider<PaperUseCase>((ref) {
  final repo = ref.watch(paperRepositoryProvider);
  return PaperUseCase(repository: repo);
});

final paperNotifierProvider =
    StateNotifierProvider<PaperNotifier, PaperState>((ref) {
  final useCase = ref.watch(paperUseCaseProvider);
  return PaperNotifier(useCase);
});
