// lib/data/models/paper_model.dart
import '../../domain/entities/paper_entity.dart';

class PaperModel extends PaperEntity {
  PaperModel({
    required String id,
    required String title,
    required List<String> authors,
    required int year,
    required String pdfUrl,
    required String uploadedBy,
    required String category,
  }) : super(
          id: id,
          title: title,
          authors: authors,
          year: year,
          pdfUrl: pdfUrl,
          uploadedBy: uploadedBy,
          category: category,
        );

  factory PaperModel.fromJson(Map<String, dynamic> json) {
    return PaperModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      authors: List<String>.from(json['authors'] ?? []),
      year: json['year'] ?? 0,
      pdfUrl: json['pdfUrl'] as String,
      uploadedBy: json['uploadedBy'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}
