import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

// Custom UI Components
import '../components/homeTopBar.dart';
import '../components/searchBar.dart';
import '../components/FilterSortRow.dart';
import '../components/ResearchPaperCard.dart';
import '../../model/PaperModel.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedSort = 'Name';
  List<PaperModel> _papers = [];
  bool _isLoading = true;
  final Set<String> _bookmarkedIds = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadPapers();
  }

  Future<void> _loadPapers() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _papers = [
        PaperModel(
          paperId: '1',
          title: 'What is the mathematical equation required to be good guy',
          averageRating: 4.7,
          pdfUrl: 'https://example.com/paper1.pdf',
          publishedDate: '2017-03-02',
          authorName: 'Chala Iwate',
          imageAsset: 'assets/avatar1.png', category: '', createdAt: DateTime(2017, 3, 2),
        ),
        PaperModel(
          paperId: '2',
          title: 'Understanding AI Ethics and Fairness',
          averageRating: 4.9,
          pdfUrl: 'https://example.com/paper2.pdf',
          publishedDate: '2020-08-14',
          authorName: 'Aynalem Taye',
          imageAsset: 'assets/avatar2.png', category: '', createdAt: DateTime(2017, 3, 2),
        ),
      ];
      _isLoading = false;
    });
  }

  void _toggleBookmark(PaperModel paper) {
    setState(() {
      if (_bookmarkedIds.contains(paper.paperId)) {
        _bookmarkedIds.remove(paper.paperId);
      } else {
        _bookmarkedIds.add(paper.paperId);
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

  List<PaperModel> _getFilteredSortedPapers() {
    List<PaperModel> filtered = _papers
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
        filtered.sort((a, b) =>
            DateTime.parse(b.publishedDate)
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
    final filteredPapers = _getFilteredSortedPapers();

    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
        child: ListView(
        padding: EdgeInsets.zero,
        children: [
        const DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
    child: Text('Menu'),
    ),
    ListTile(
    title: const Text('Logout'),
    onTap: () => Navigator.pop(context),
    ),
    ],
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
    child: _isLoading
    ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
    itemCount: filteredPapers.length,
    itemBuilder: (context, index) {
    final paper = filteredPapers[index];
    return ResearchPaperCard(
    title: paper.title,
    imageAsset: paper.imageAsset,
    rating: paper.averageRating,
    pdfUrl: paper.pdfUrl,
    publishedDate: paper.publishedDate,
    authorName: paper.authorName,
    isBookmarked:
    _bookmarkedIds.contains(paper.paperId),
    onReadClick: () => _openPdf(paper.pdfUrl),
    onBookmarkClick: () => _toggleBookmark(paper), onNavigate: () {  },
    );
    },
    ),
    ),
    ],
    ),
    ),),);}}
