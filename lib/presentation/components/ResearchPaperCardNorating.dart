// lib/presentation/components/ResearchPaperCardNorating.dart

import 'package:flutter/material.dart';

class ResearchPaperCardNorating extends StatelessWidget {
  final String paperId;
  final String title;
  final String imageAsset;
  final String publishedDate;
  final String authorName;
  final VoidCallback onDelete; // make non-nullable

  const ResearchPaperCardNorating({
    super.key,
    required this.paperId,
    required this.title,
    required this.imageAsset,
    this.publishedDate = "Placeholder Date",
    this.authorName = "Placeholder Author",
    // default to empty callback so delete icon always shows
    this.onDelete = _defaultDeleteCallback,
  });

  static void _defaultDeleteCallback() {
    // no-op
  }

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
            // Title + Avatar + Delete
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
                // always show delete icon
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete Paper?'),
                        content:
                            Text('Are you sure you want to delete "$title"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      onDelete();
                    }
                  },
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
                  onPressed: () {}, // leave as-is
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
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.file_download_outlined,
                      color: Colors.white, size: 20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Colors.white, size: 20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _infoStyle() => const TextStyle(
        fontSize: 10,
        color: Colors.white70,
      );
}
