// lib/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/%20viewmodels/PaperNotifier.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/paper_entity.dart';
import '../../application/providers/paper_provider.dart';
import '../../presentation/components/homeTopBar.dart';
import '../../presentation/components/searchBar.dart';
import '../../presentation/components/FilterSortRow.dart';
import '../../presentation/components/ResearchPaperCard.dart';
import '../../presentation/components/drawer.dart';
import "../../presentation/ viewmodels/bookmark_provider.dart";
import "../../model/PaperModel.dart";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedSort = 'Name';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paperNotifierProvider.notifier).fetchPapers();
    });
  }

  List<PaperEntity> _filterPapers(List<PaperEntity> papers) {
    var filtered = papers
        .where(
            (p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    if (_selectedFilter == 'Favorites') {
      final bookmarks = ref.watch(bookmarkNotifierProvider);
      filtered = filtered
          .where((p) => bookmarks.any((b) => b.paperId == p.id))
          .toList();
    }
    // you could also sort here based on _selectedSort if desired
    return filtered;
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paperNotifierProvider);
    final notifier = ref.read(paperNotifierProvider.notifier);
    final bookmarks = ref.watch(bookmarkNotifierProvider);

    final filtered = _filterPapers(state.papers);

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              HomeTopBar(
                onMenuClick: () => _scaffoldKey.currentState?.openDrawer(),
                inputName: 'IntelliReview',
                onNotificationClick: () {},
              ),

              const SizedBox(height: 16),

              // Search bar
              CustomSearchBar(
                query: _searchQuery,
                onQueryChanged: (value) => setState(() => _searchQuery = value),
              ),

              const SizedBox(height: 12),

              // Filter/Sort row
              FilterSortRow(
                selectedFilter: _selectedFilter,
                selectedSort: _selectedSort,
                onFilterSelected: (value) =>
                    setState(() => _selectedFilter = value),
                onSortSelected: (value) =>
                    setState(() => _selectedSort = value),
              ),

              const SizedBox(height: 8),

              // Paper list
              Expanded(
                child: state.status == PaperStatus.error
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                        ? const Center(child: Text('No papers found'))
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final paper = filtered[index];
                              return ResearchPaperCard(
                                paper: paper,
                                paperId: paper.id,
                                title: paper.title,
                                imageAsset: 'assets/images/research_paper.png',
                                rating: 0.0,
                                pdfUrl: paper.pdfUrl,
                                isBookmarked:
                                    bookmarks.any((b) => b.paperId == paper.id),
                                publishedDate: paper.year.toString(),
                                authorName: paper.authors.join(', '),
                                onReadClick: () => _openPdf(paper.pdfUrl),
                                onBookmarkClick: () {
                                  final paperModel = PaperModel(
                                    paperId: paper.id,
                                    title: paper.title,
                                    averageRating: 0.0,
                                    pdfUrl: paper.pdfUrl,
                                    publishedDate: paper.year.toString(),
                                    authorName: paper.authors.join(', '),
                                    imageAsset: 'assets/avatar_placeholder.png',
                                    category: 'Default Category',
                                    createdAt: DateTime.now(),
                                  );

                                  ref
                                      .read(bookmarkNotifierProvider.notifier)
                                      .toggleBookmark(paperModel);
                                },
                                onCommentClick: () =>
                                    context.go('/commenting', extra: paper),
                                onNavigate: () {/* your navigation logic */},
                                onEdit: (newTitle, newAuthors) async {
                                  await notifier.updatePaper(
                                    paper.id,
                                    newTitle,
                                    newAuthors.split(','),
                                  );
                                  notifier.fetchPapers();
                                },
                              );
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
