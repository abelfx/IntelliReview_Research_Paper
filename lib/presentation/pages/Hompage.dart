import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/%20viewmodels/bookmark_provider.dart';
import 'package:frontend/presentation/components/app_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

// Import your notifier provider and entities
import '../../domain/entities/paper_entity.dart';
import "../../application/providers/paper_provider.dart";

// Your PaperModel for UI, or you can adapt PaperEntity directly
import '../../model/PaperModel.dart';

// Your UI components
import '../components/homeTopBar.dart';
import '../components/searchBar.dart';
import '../components/FilterSortRow.dart';
import '../components/ResearchPaperCard.dart';
import "../components/drawer.dart";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedSort = 'Name';
  final Set<String> _bookmarkedIds = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Fetch papers when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paperNotifierProvider.notifier).fetchPapers();
    });
  }

  void _toggleBookmark(String paperId) {
  setState(() {
    if (_bookmarkedIds.contains(paperId)) {
      _bookmarkedIds.remove(paperId);
    } else {
      _bookmarkedIds.add(paperId);
    }
  });
}


  Future<void> _openPdf(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid PDF URL')),
      );
      return;
    }

    try {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening PDF: ${e.toString()}')),
      );
    }
  }

  // Helper: convert PaperEntity to PaperModel for UI
  PaperModel _toPaperModel(PaperEntity p) {
    return PaperModel(
      paperId: p.id,
      title: p.title,
      averageRating: 0,
      pdfUrl: p.pdfUrl,
      publishedDate: p.year > 0 ? p.year.toString() : DateTime.now().toString(),
      authorName: p.authors.isNotEmpty ? p.authors.join(', ') : 'Unknown',
      imageAsset: 'assets/avatar_placeholder.png', // placeholder
      category: p.category,
      createdAt: DateTime.tryParse("today" ?? '') ?? DateTime.now(),
    );
  }
  

  List<PaperModel> _getFilteredSortedPapers(List<PaperModel> papers) {
    var filtered = papers
        .where((paper) =>
            paper.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    if (_selectedFilter == 'Favorites') {
      filtered = filtered
          .where((paper) => _bookmarkedIds.contains(paper.paperId))
          .toList();
    }

    switch (_selectedSort) {
      case 'Name':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Date':
        filtered.sort((a, b) => DateTime.parse(b.publishedDate)
            .compareTo(DateTime.parse(a.publishedDate)));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
    }

    return filtered;
  }
  

  @override
  Widget build(BuildContext context) {
    late BookmarkNotifier bookmarkNotifier;

    final state = ref.watch(paperNotifierProvider);
    final notifier = ref.read(paperNotifierProvider.notifier);
final bookmarkedPapers = ref.watch(bookmarkNotifierProvider);
bookmarkNotifier = ref.read(bookmarkNotifierProvider.notifier);

    List<PaperModel> papers = [];
    bool isLoading = false;
    String? error;

    papers = state.papers.map(_toPaperModel).toList();

    final filteredPapers = _getFilteredSortedPapers(papers);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: DrawerContent(
          onLogout: () {
            // Clear shared preferences or do logout logic here
            // You can also use a provider if you manage auth state
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged out successfully')),
            );
          },
          onNavigate: (route) {
            Navigator.pop(context); // close the drawer
            context.go(route); // navigate to the selected route
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              HomeTopBar(
                onMenuClick: () => _scaffoldKey.currentState?.openDrawer(),
                inputName: 'IntelliReview',
                onNotificationClick: () {
                  // Future implementation
                },
              ),
              const SizedBox(height: 16),
              CustomSearchBar(
                query: _searchQuery,
                onQueryChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              FilterSortRow(
                selectedFilter: _selectedFilter,
                selectedSort: _selectedSort,
                onFilterSelected: (value) {
                  setState(() {
                    _selectedFilter = value;
                  });
                },
                onSortSelected: (value) {
                  setState(() {
                    _selectedSort = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                        ? Center(child: Text(error))
                        : filteredPapers.isEmpty
                            ? const Center(child: Text('No papers found'))
                            : ListView.builder(
                                itemCount: filteredPapers.length,
                                itemBuilder: (context, index) {
                                  final paper = filteredPapers[index];
                                   final isBookmarked = bookmarkedPapers.any((b) => b.paperId == paper.paperId);
                                  return ResearchPaperCard(
                                      title: paper.title,
                                      imageAsset: paper.imageAsset,
                                      rating: paper.averageRating,
                                      pdfUrl: paper.pdfUrl,
                                      publishedDate: paper.publishedDate,
                                      authorName: paper.authorName,
                                      isBookmarked: _bookmarkedIds
                                          .contains(paper.paperId),
                                      onReadClick: () => _openPdf(paper.pdfUrl),
                                      onBookmarkClick: () =>
                                           ref.read(bookmarkNotifierProvider.notifier).toggleBookmark(paper),
                                      onCommentClick: () {
                               context.go('/commenting', extra: paper);
},

                                      onNavigate: () {});
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
