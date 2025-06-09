import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/ viewmodels/bookmark_bloc.dart';
import 'package:frontend/presentation/ viewmodels/bookmark_event.dart';
import 'package:frontend/presentation/ viewmodels/bookmark_state.dart';
import '../components/BookmarkCard.dart';
import '../components/drawer.dart';
import '../components/homeTopBar.dart';
import '../components/searchBar.dart';
import '../components/FilterSortRow.dart';

class BookmarkScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const BookmarkScreen({super.key, required this.onLogout});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  String query = '';
  String selectedFilter = 'All';
  String selectedSort = 'Name';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<BookmarkBloc>().add(FetchBookmarksEvent());
  }

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerContent(onLogout: widget.onLogout, onNavigate: (r) {}),
      appBar: HomeTopBar(
        inputName: "Bookmarks",
        onMenuClick: _openDrawer,
        onNotificationClick: () =>
            Navigator.pushNamed(context, '/createNotification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomSearchBar(
                query: query, onQueryChanged: (v) => setState(() => query = v)),
            const SizedBox(height: 12),
            FilterSortRow(
              selectedFilter: selectedFilter,
              onFilterSelected: (v) => setState(() => selectedFilter = v),
              selectedSort: selectedSort,
              onSortSelected: (v) => setState(() => selectedSort = v),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<BookmarkBloc, BookmarkState>(
                builder: (context, state) {
                  if (state is BookmarkLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is BookmarkErrorState) {
                    return Center(child: Text(state.message));
                  }
                  if (state is BookmarkLoadedState) {
                    final filtered = state.papers
                        .where((p) =>
                            p.title.toLowerCase().contains(query.toLowerCase()))
                        .where((p) =>
                            selectedFilter == 'All' ||
                            p.category == selectedFilter)
                        .toList()
                      ..sort((a, b) {
                        if (selectedSort == 'Name') {
                          return a.title.compareTo(b.title);
                        } else if (selectedSort == 'Date') {
                          return b.createdAt.compareTo(a.createdAt);
                        }
                        return 0;
                      });

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text("No bookmarks yet",
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                      );
                    }

                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => BookmarkCard(
                        paper: filtered[i],
                        isBookmarked: true,
                        onBookmarkClick: () => context
                            .read<BookmarkBloc>()
                            .add(ToggleBookmarkEvent(filtered[i])),
                        onTap: () => Navigator.pushNamed(
                            context, '/paperDetail/${filtered[i].paperId}'),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
