// lib/domain/entities/paper_entity.dart
class PaperEntity {
  final String id;
  final String title;
  final List<String> authors;
  final int year;
  final String pdfUrl;
  final String uploadedBy;
  final String category;

  PaperEntity({
    required this.id,
    required this.title,
    required this.authors,
    required this.year,
    required this.pdfUrl,
    required this.uploadedBy,
    required this.category,
  });
}
