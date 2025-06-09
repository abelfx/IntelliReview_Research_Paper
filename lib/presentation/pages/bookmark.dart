// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../ viewmodels/bookmark_bloc.dart';
// import '../../model/PaperModel.dart';
// import '../components/BookmarkCard.dart';

// import '../components/drawer.dart';
// import '../components/homeTopBar.dart';

// import '../components/searchBar.dart';

// import '../components/FilterSortRow.dart';
// class BookmarkScreen extends StatefulWidget {
//   final VoidCallback onLogout;

//   const BookmarkScreen({super.key, required this.onLogout});

//   @override
//   State<BookmarkScreen> createState() => _BookmarkScreenState();
// }

// class _BookmarkScreenState extends State<BookmarkScreen> {
//   String query = '';
//   String selectedFilter = 'All';
//   String selectedSort = 'Name';
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   void _onDrawerOpen() {
//     _scaffoldKey.currentState?.openDrawer();
//   }

//   @override
//   void initState() {
//     super.initState();
//     context.read<BookmarkBloc>().add(FetchBookmarksEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: DrawerContent(
//         onLogout: widget.onLogout, onNavigate: (String route) {  },
//       ),
//       appBar: HomeTopBar(
//         inputName: "Bookmarks",
//         onMenuClick: _onDrawerOpen,
//         onNotificationClick: () {
//           Navigator.pushNamed(context, '/createNotification');
//         },
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             CustomSearchBar(
//               query: query, onQueryChanged: (String value) {  },

//             ),
//             const SizedBox(height: 12),
//             FilterSortRow(
//               selectedFilter: selectedFilter,
//               onFilterSelected: (val) => setState(() => selectedFilter = val),
//               selectedSort: selectedSort,
//               onSortSelected: (val) => setState(() => selectedSort = val),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: BlocBuilder<BookmarkBloc, BookmarkState>(
//                 builder: (context, state) {
//                   if (state is BookmarkLoadingState) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is BookmarkErrorState) {
//                     return Center(child: Text(state.message));
//                   } else if (state is BookmarkLoadedState) {
//                     final filtered = state.papers
//                         .where((paper) =>
//                         paper.title.toLowerCase().contains(query.toLowerCase()))
//                         .where((paper) =>
//                     selectedFilter == 'All' || paper.category == selectedFilter)
//                         .toList()
//                       ..sort((a, b) {
//                         if (selectedSort == 'Name') {
//                           return a.title.compareTo(b.title);
//                         } else if (selectedSort == 'Date') {
//                           return b.createdAt.compareTo(a.createdAt);
//                         }
//                         return 0;
//                       });

//                     if (filtered.isEmpty) {
//                       return const EmptyBookmarksState();
//                     }

//                     return ListView.separated(
//                       itemCount: filtered.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 12),
//                       itemBuilder: (context, index) {
//                         final paper = filtered[index];
//                         return BookmarkCard(
//                           paper: paper,
//                           isBookmarked: true,
//                           onBookmarkClick: () {
//                             context.read<BookmarkBloc>().add(ToggleBookmarkEvent(paper));
//                           },
//                           onTap: () {
//                             Navigator.pushNamed(context, '/paperDetail/${paper.paperId}');
//                           },
//                         );
//                       },
//                     );
//                   }
//                   return const SizedBox.shrink();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EmptyBookmarksState extends StatelessWidget {
//   const EmptyBookmarksState({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         "No bookmarks yet",
//         style: TextStyle(fontSize: 16, color: Colors.grey),
//       ),
//     );
//   }
// }
