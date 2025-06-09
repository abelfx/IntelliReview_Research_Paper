import 'package:flutter/material.dart';

import '../components/homeTopBar.dart';
import '../components/ResearchPaperCard.dart';
import '../components/BottomNavBar.dart';
import '../components/drawer.dart';

class CommentingPage extends StatefulWidget {
  final int selectedBottomNavItem;
  final Function(int) onBottomNavItemSelected;

  const CommentingPage({
    super.key,
    this.selectedBottomNavItem = 0,
    required this.onBottomNavItemSelected,
  });

  @override
  State<CommentingPage> createState() => _CommentingPageState();
}

class _CommentingPageState extends State<CommentingPage> {
  final TextEditingController _commentController = TextEditingController();
  int rating = 0;
  final List<String> comments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerContent(onLogout: () {
          // Handle logout: just close drawer for now
          Navigator.pop(context);
        }, onNavigate: (String route) {  },),
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
                  onPressed: () {
                    final comment = _commentController.text.trim();
                    if (comment.isNotEmpty) {
                      setState(() {
                        comments.insert(0, comment);
                        _commentController.clear();
                        rating = 0; // reset rating on send
                      });
                    }
                  },
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
          BottomNavBar(
            selectedIndex: widget.selectedBottomNavItem,
            onItemSelected: widget.onBottomNavItemSelected,
            role: "user",
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ResearchPaperCard(
              title: "Deep Learning Approaches in Medical Imaging",
              imageAsset: 'assets/research_paper.png',
              rating: 4.5,
              pdfUrl: "https://example.com/sample.pdf",
              isBookmarked: false,
              onBookmarkClick: () {
                // Handle bookmark toggle
              },
              onReadClick: () {
                // Handle PDF read
              },
              onNavigate: () {
                // Navigate to detail page
              },
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
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              rating = i + 1;
                            });
                          },
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
            comments.isEmpty
                ? const Text("No comments yet.")
                : Column(
              children: comments.map((comment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/user_placeholder.png',
                          width: 40,
                          height: 40,
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
                          child: Text(comment),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
