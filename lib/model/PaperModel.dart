class PaperModel {
  final String paperId;
  final String title;
  final double averageRating;
  final String pdfUrl;
  final String publishedDate;
  final String authorName;
  final String imageAsset;

  // Add these two fields
  final String category;
  final DateTime createdAt;

  PaperModel({
    required this.paperId,
    required this.title,
    required this.averageRating,
    required this.pdfUrl,
    required this.publishedDate,
    required this.authorName,
    required this.imageAsset,
    required this.category,
    required this.createdAt,
  });

  factory PaperModel.fromJson(Map<String, dynamic> json) {
    return PaperModel(
      paperId: json['paperId'] ?? '',
      title: json['title'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      pdfUrl: json['pdfUrl'] ?? '',
      publishedDate: json['publishedDate'] ?? '',
      authorName: json['authorName'] ?? '',
      imageAsset: json['imageAsset'] ?? '',
      category: json['category'] ?? 'General',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'paperId': paperId,
    'title': title,
    'averageRating': averageRating,
    'pdfUrl': pdfUrl,
    'publishedDate': publishedDate,
    'authorName': authorName,
    'imageAsset': imageAsset,
    'category': category,
    'createdAt': createdAt.toIso8601String(),
  };
}
