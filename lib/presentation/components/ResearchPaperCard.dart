// lib/presentation/components/ResearchPaperCard.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/model/PaperModel.dart';
import 'package:frontend/domain/entities/paper_entity.dart';

class ResearchPaperCard extends StatelessWidget {
  final String paperId;
  final String title;
  final String imageAsset;
  final double rating;
  final String pdfUrl;
  final bool isBookmarked;
  final VoidCallback onReadClick;
  final VoidCallback onBookmarkClick;
  final VoidCallback onCommentClick;
  final VoidCallback onNavigate;
  final Future<void> Function(String newTitle, String newAuthors) onEdit;
  final String publishedDate;
  final String authorName;
  final PaperEntity paper;

  const ResearchPaperCard({
    super.key,
    required this.paperId,
    required this.title,
    required this.imageAsset,
    required this.rating,
    required this.pdfUrl,
    required this.isBookmarked,
    required this.onCommentClick,
    required this.onReadClick,
    required this.onBookmarkClick,
    required this.onNavigate,
    required this.onEdit,
    this.publishedDate = "12/05/2025",
    this.authorName = "John Bereket",
    required this.paper,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF5D5CBB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title row with Edit icon
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(imageAsset),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _showEditDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text("Published: $publishedDate", style: _infoStyle()),
            Text("Author: $authorName", style: _infoStyle()),
            const SizedBox(height: 12),

            Row(
              children: [
                ElevatedButton(
                  onPressed: onReadClick,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text(
                    "Read",
                    style: TextStyle(
                      color: Color(0xFF5D5CBB),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.star, color: Colors.yellow, size: 20),
                const SizedBox(width: 4),
                Text("$rating", style: const TextStyle(color: Colors.white)),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: onBookmarkClick,
                ),
                _iconButton(
                  context,
                  icon: Icons.file_download_outlined,
                  tooltip: "Download",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Downloading...")),
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Downloaded")),
                      );
                    });
                  },
                ),
                _iconButton(
                  context,
                  icon: Icons.chat_bubble_outline,
                  tooltip: "Comment",
                  onPressed: () => context.go(
                    '/commenting',
                    extra: PaperModel(
                      paperId: 'demo-id',
                      title: 'Demo Paper',
                      averageRating: 4.5,
                      pdfUrl: 'https://example.com/demo.pdf',
                      publishedDate: '2024-01-01',
                      authorName: 'Demo Author',
                      imageAsset: 'assets/avatar_placeholder.png',
                      category: 'Demo Category',
                      createdAt: DateTime.now(),
                    ),
                  ),
                ),
                _iconButton(
                  context,
                  icon: Icons.share,
                  tooltip: "Share",
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: pdfUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Link copied")),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Edit dialog
  void _showEditDialog(BuildContext context) {
    final titleCtl = TextEditingController(text: title);
    final authorsCtl = TextEditingController(text: authorName);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Edit Paper"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleCtl,
                decoration: const InputDecoration(labelText: "Title")),
            TextField(
                controller: authorsCtl,
                decoration: const InputDecoration(labelText: "Authors")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Future.microtask(() {
                onEdit(titleCtl.text, authorsCtl.text);
              });
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  TextStyle _infoStyle() =>
      const TextStyle(fontSize: 10, color: Colors.white70);

  Widget _iconButton(BuildContext context,
      {required IconData icon,
      required String tooltip,
      required VoidCallback onPressed}) {
    return IconButton(
        icon: Icon(icon, size: 20, color: Colors.white),
        tooltip: tooltip,
        onPressed: onPressed);
  }
}
