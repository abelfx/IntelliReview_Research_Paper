// lib/domain/repositories/paper_repository.dart
import '../entities/paper_entity.dart';

abstract class PaperRepository {
  Future<PaperEntity> uploadPaper(
    String title,
    List<String> authors,
    int year,
    String uploadedBy,
    String category,
    String filePath,
  );
  Future<PaperEntity> updatePaper(
    String id,
    String title,
    List<String> authors,
    int year,
    String category,
    String? filePath,
  );
  Future<List<PaperEntity>> viewPapers();
  Future<void> deletePaper(String id);
}
