import 'package:flutter/material.dart';
import '../../model/PaperModel.dart'; // Adjust to your actual model path

class BookmarkCard extends StatelessWidget {
  final PaperModel paper;
  final bool isBookmarked;
  final VoidCallback onBookmarkClick;
  final VoidCallback onTap;

  const BookmarkCard({
    Key? key,
    required this.paper,
    required this.isBookmarked,
    required this.onBookmarkClick,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Image.asset(
                'assets/research_paper.png',
                width: 48,
                height: 48,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  paper.title ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: onBookmarkClick,
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Theme.of(context).colorScheme.primary,
                ),
                tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
