import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/%20viewmodels/bookmark_provider.dart';
import '../../model/PaperModel.dart';
import '../components/BookmarkCard.dart';
import '../components/drawer.dart';
import '../components/homeTopBar.dart';
import '../components/searchBar.dart';
import '../components/FilterSortRow.dart';

class BookmarkScreen extends ConsumerStatefulWidget {
  const BookmarkScreen({super.key});

  @override
  ConsumerState<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends ConsumerState<BookmarkScreen> {
  String query = '';
  String selectedFilter = 'All';
  String selectedSort = 'Name';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  void _onDrawerOpen() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkedPapers = ref.watch(bookmarkNotifierProvider);


    final bookmarks = ref.watch(bookmarkNotifierProvider);

    final filtered = bookmarks
        .where((paper) => paper.title.toLowerCase().contains(query.toLowerCase()))
        .where((paper) => selectedFilter == 'All' || paper.category == selectedFilter)
        .toList()
      ..sort((a, b) {
        if (selectedSort == 'Name') {
          return a.title.compareTo(b.title);
        } else if (selectedSort == 'Date') {
          return b.createdAt.compareTo(a.createdAt);
        }
        return 0;
      });

    return Scaffold(
      key: _scaffoldKey,
      appBar: HomeTopBar(
        inputName: "Bookmarks",
        onMenuClick: _onDrawerOpen,
        onNotificationClick: () {
          Navigator.pushNamed(context, '/createNotification');
        },
      ),
      drawer: DrawerContent(
        onLogout: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logged out")),
          );
        },
        onNavigate: (route) {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomSearchBar(
              query: query,
              onQueryChanged: (String value) {
                setState(() => query = value);
              },
            ),
            const SizedBox(height: 12),
            FilterSortRow(
              selectedFilter: selectedFilter,
              onFilterSelected: (val) => setState(() => selectedFilter = val),
              selectedSort: selectedSort,
              onSortSelected: (val) => setState(() => selectedSort = val),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? const EmptyBookmarksState()
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final paper = filtered[index];
                        return BookmarkCard(
                          paper: paper,
                          isBookmarked: true,
                          onBookmarkClick: () {
                            ref.read(bookmarkNotifierProvider.notifier).toggleBookmark(paper);
                          },
                          onTap: () {
                            Navigator.pushNamed(context, '/paperDetail/${paper.paperId}');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyBookmarksState extends StatelessWidget {
  const EmptyBookmarksState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "No bookmarks yet",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
