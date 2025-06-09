import 'package:flutter/material.dart';


class ResearchPaperCardNorating extends StatelessWidget {
  final String title;
  final String imageAsset;
  final String publishedDate;
  final String authorName;

  const ResearchPaperCardNorating({
    super.key,
    required this.title,
    required this.imageAsset,
    this.publishedDate = "Placeholder Date",
    this.authorName = "Placeholder Author",
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
              ],
            ),
            const SizedBox(height: 4),
            Text("Published: $publishedDate", style: _infoStyle()),
            Text("Author: $authorName", style: _infoStyle()),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
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
                  icon:
                  const Icon(Icons.share, color: Colors.white, size: 20),
                  onPressed: () {},
                ),
              ],
            )
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
