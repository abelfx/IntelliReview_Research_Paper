import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/providers/review_provider.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:frontend/domain/entities/paper_entity.dart';
import 'package:frontend/model/PaperModel.dart';
import '../components/homeTopBar.dart';
import '../components/ResearchPaperCard.dart';
import '../components/app_bottom_nav_bar.dart';
import '../components/drawer.dart';
import "../../router/app_router.dart";
import 'package:go_router/go_router.dart';

class CommentingPage extends ConsumerStatefulWidget {
  final PaperModel paper;

  const CommentingPage({super.key, required this.paper});

  // Add a named constructor for demo usage
  factory CommentingPage.demo() => CommentingPage(
        paper: PaperModel(
          paperId: 'demo-id',
          title: 'Physics',
          averageRating: 4.5,
          pdfUrl: 'https://example.com/demo.pdf',
          publishedDate: '2024-01-01',
          authorName: 'Demo Author',
          imageAsset: 'assets/avatar_placeholder.png',
          category: 'Demo Category',
          createdAt: DateTime.now(),
        ),
      );

  @override
  ConsumerState<CommentingPage> createState() => _CommentingPageState();
}

class _CommentingPageState extends ConsumerState<CommentingPage> {
  final TextEditingController _commentController = TextEditingController();
  int rating = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      drawer: Drawer(
        child: DrawerContent(
          onLogout: () => context.go('/login'),
          onNavigate: (route) {
            Navigator.pop(context);
            GoRouter.of(context).go(route);
          },
        ),
      ),
      appBar: HomeTopBar(
        onMenuClick: () => _scaffoldKey.currentState?.openDrawer(),
        inputName: 'Comments',
        onNotificationClick: () {},
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
                paper: PaperEntity(
                    id: "ID",
                    title: "title",
                    authors: [],
                    year: 2010,
                    pdfUrl: "https:/",
                    uploadedBy: "john B",
                    category: "machine learning"),
                paperId: "0",
                title: widget.paper.title,
                imageAsset:
                    widget.paper.imageAsset ?? 'assets/research_paper.png',
                rating: widget.paper.averageRating ?? 0,
                pdfUrl: widget.paper.pdfUrl,
                isBookmarked: false,
                onCommentClick: () {},
                onBookmarkClick: () {},
                onReadClick: () {},
                onNavigate: () {},
                onEdit: (newTitle, newAuthors) async {}),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFFa9a8db),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
                            color:
                                (i + 1) <= rating ? Colors.amber : Colors.white,
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
                                  'data:image/jpeg;base64,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',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECECFB),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(review.comment),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Rating: ${review.rating ?? "N/A"}",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
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
