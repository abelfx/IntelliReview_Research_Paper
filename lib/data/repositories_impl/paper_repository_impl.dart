// lib/data/repositories_impl/paper_repository_impl.dart
import '../../domain/entities/paper_entity.dart';
import '../../domain/repositories/paper_repository.dart';
import '../datasources/paper_datasource.dart';

class PaperRepositoryImpl implements PaperRepository {
  final PaperDataSource dataSource;
  PaperRepositoryImpl({required this.dataSource});

  @override
  Future<PaperEntity> uploadPaper(
    String title,
    List<String> authors,
    int year,
    String uploadedBy,
    String category,
    String filePath,
  ) {
    return dataSource.uploadPaper(
      title: title,
      authors: authors,
      year: year,
      uploadedBy: uploadedBy,
      category: category,
      filePath: filePath,
    );
  }

  @override
  Future<PaperEntity> updatePaper(
    String id,
    String title,
    List<String> authors,
    int year,
    String category,
    String? filePath,
  ) {
    return dataSource.updatePaper(
      id: id,
      title: title,
      authors: authors,
      year: year,
      category: category,
      filePath: filePath,
    );
  }

  @override
  Future<List<PaperEntity>> viewPapers() {
    return dataSource.viewPapers();
  }

  @override
  Future<void> deletePaper(String id) {
    return dataSource.deletePaper(id);
  }
}
