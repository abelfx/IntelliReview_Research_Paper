import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/PaperModel.dart';

class BookmarkNotifier extends StateNotifier<List<PaperModel>> {
  BookmarkNotifier() : super([]);

  void toggleBookmark(PaperModel paper) {
    final exists = state.any((p) => p.paperId == paper.paperId);
    state = exists
        ? state.where((p) => p.paperId != paper.paperId).toList()
        : [...state, paper];
  }

  bool isBookmarked(String id) =>
      state.any((p) => p.paperId == id);
}

final bookmarkNotifierProvider =
    StateNotifierProvider<BookmarkNotifier, List<PaperModel>>(
  (ref) => BookmarkNotifier(),
);
