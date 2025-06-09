import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/providers/review_provider.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:frontend/model/PaperModel.dart';
import '../components/homeTopBar.dart';
import '../components/ResearchPaperCard.dart';
import '../components/app_bottom_nav_bar.dart';
import '../components/drawer.dart';

class CommentingPage extends ConsumerStatefulWidget {
  final PaperModel paper;

  const CommentingPage({super.key, required this.paper});

  @override
  ConsumerState<CommentingPage> createState() => _CommentingPageState();
}

class _CommentingPageState extends ConsumerState<CommentingPage> {
  final TextEditingController _commentController = TextEditingController();
  int rating = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reviewNotifierProvider.notifier).loadReviews();
    });
  }

  void _submitComment() {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty && rating > 0) {
      final user = ref.read(currentUserProvider);
      ref.read(reviewNotifierProvider.notifier).createReview(
            widget.paper.paperId,
            user?.id,
            rating.toString(),
            comment,
          );

      _commentController.clear();
      setState(() => rating = 0);
    }
  }


  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(reviewNotifierProvider);

    return Scaffold(
      drawer: Drawer(
        child: DrawerContent(
          onLogout: () => Navigator.pop(context),
          onNavigate: (String route) {},
        ),
      ),
      appBar: HomeTopBar(
        inputName: "Comment",
        onMenuClick: () => Scaffold.of(context).openDrawer(),
        onNotificationClick: () {
          Navigator.pushNamed(context, '/notifications');
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Write a comment...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF5D5CBB)),
                  onPressed: _submitComment,
                ),
                filled: true,
                fillColor: const Color(0xFFECECFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ResearchPaperCard(
              title: widget.paper.title,
              imageAsset: widget.paper.imageAsset ?? 'assets/research_paper.png',
              rating: widget.paper.averageRating ?? 0,
              pdfUrl: widget.paper.pdfUrl,
              isBookmarked: false,
              onCommentClick: () {},
              onBookmarkClick: () {},
              onReadClick: () {},
              onNavigate: () {},
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFFa9a8db),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "What do you think?",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        return IconButton(
                          onPressed: () => setState(() => rating = i + 1),
                          icon: Icon(
                            Icons.star,
                            color: (i + 1) <= rating ? Colors.amber : Colors.white,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            reviewsAsync.when(
              data: (reviews) => reviews.isEmpty
                  ? const Text("No comments yet.")
                  : Column(
                      children: reviews.map((review) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  'https://example.com/default_avatar.png',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECECFB),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(review.comment),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Rating: ${review.rating ?? "N/A"}",
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text("Error loading comments: $err"),
            ),
          ],
        ),
      ),
    );
  }
}
