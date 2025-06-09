// lib/application/providers/paper_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/paper_usecase.dart';
import '../../domain/entities/paper_entity.dart';
import '../../data/datasources/paper_datasource.dart';
import '../../data/repositories_impl/paper_repository_impl.dart';

enum PaperStatus { initial, loading, loaded, error }

class PaperNotifier extends StateNotifier<PaperStatus> {
  final PaperUseCase useCase;
  List<PaperEntity> papers = [];
  String? errorMessage;

  PaperNotifier(this.useCase) : super(PaperStatus.initial);

  Future<void> fetchPapers() async {
    state = PaperStatus.loading;
    try {
      papers = await useCase.viewPapers();
      state = PaperStatus.loaded;
    } catch (e) {
      errorMessage = e.toString();
      state = PaperStatus.error;
    }
  }

  Future<void> addPaper(
    String title,
    List<String> authors,
    int year,
    String uploadedBy,
    String category,
    String filePath,
  ) async {
    state = PaperStatus.loading;
    try {
      final newPaper = await useCase.uploadPaper(
          title, authors, year, uploadedBy, category, filePath);
      papers.add(newPaper);
      state = PaperStatus.loaded;
    } catch (e) {
      errorMessage = e.toString();
      state = PaperStatus.error;
    }
  }

  Future<void> modifyPaper(
    String id,
    String title,
    List<String> authors,
    int year,
    String category,
    String? filePath,
  ) async {
    state = PaperStatus.loading;
    try {
      final updated = await useCase.updatePaper(
          id, title, authors, year, category, filePath);
      final index = papers.indexWhere((p) => p.id == id);
      if (index != -1) papers[index] = updated;
      state = PaperStatus.loaded;
    } catch (e) {
      errorMessage = e.toString();
      state = PaperStatus.error;
    }
  }

  Future<void> removePaper(String id) async {
    state = PaperStatus.loading;
    try {
      await useCase.deletePaper(id);
      papers.removeWhere((p) => p.id == id);
      state = PaperStatus.loaded;
    } catch (e) {
      errorMessage = e.toString();
      state = PaperStatus.error;
    }
  }
}

final paperDataSourceProvider = Provider((ref) => PaperDataSource());
final paperRepositoryProvider = Provider((ref) {
  final ds = ref.watch(paperDataSourceProvider);
  return PaperRepositoryImpl(dataSource: ds);
});
final paperUseCaseProvider = Provider((ref) {
  final repo = ref.watch(paperRepositoryProvider);
  return PaperUseCase(repository: repo);
});
final paperNotifierProvider =
    StateNotifierProvider<PaperNotifier, PaperStatus>((ref) {
  final uc = ref.watch(paperUseCaseProvider);
  return PaperNotifier(uc);
});
