import 'package:flutter/material.dart';
import '../../model/PaperModel.dart';

class BookmarkCard extends StatelessWidget {
  final PaperModel paper;
  final bool isBookmarked;
  final VoidCallback onBookmarkClick;
  final VoidCallback onTap;

  const BookmarkCard({
    super.key,
    required this.paper,
    required this.isBookmarked,
    required this.onBookmarkClick,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF5F58C9), // Purple background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Placeholder for circle avatar
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),

            // Title
            Expanded(
              child: Text(
                paper.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // More icon
            const Icon(Icons.more_vert, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
