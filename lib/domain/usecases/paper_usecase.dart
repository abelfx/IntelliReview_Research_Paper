// lib/domain/usecases/paper_usecase.dart

import '../entities/paper_entity.dart';
import '../repositories/paper_repository.dart';

class PaperUseCase {
  final PaperRepository repository;
  PaperUseCase({required this.repository});

  Future<PaperEntity> uploadPaper(String title, List<String> authors, int year,
          String uploadedBy, String category, String filePath) =>
      repository.uploadPaper(
          title, authors, year, uploadedBy, category, filePath);

  Future<PaperEntity> updatePaper(String id, String title, List<String> authors,
          int year, String category, String? filePath) =>
      repository.updatePaper(id, title, authors, year, category, filePath);

  Future<List<PaperEntity>> viewPapers() => repository.viewPapers();

  Future<void> deletePaper(String id) => repository.deletePaper(id);
}
