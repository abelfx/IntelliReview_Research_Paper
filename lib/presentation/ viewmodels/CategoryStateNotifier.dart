// lib/presentation/viewmodels/bookmark_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/PaperModel.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

/// Bloc that manages a list of bookmarked papers.
class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc() : super(BookmarkLoadingState()) {
    on<FetchBookmarksEvent>(_onFetch);
    on<ToggleBookmarkEvent>(_onToggle);
  }

  final List<PaperModel> _bookmarks = [];

  Future<void> _onFetch(
      FetchBookmarksEvent event, Emitter<BookmarkState> emit) async {
    emit(BookmarkLoadingState());
    try {
      // In a real app you might load from local storage or a DB.
      await Future.delayed(const Duration(milliseconds: 200));
      emit(BookmarkLoadedState(List.from(_bookmarks)));
    } catch (e) {
      emit(BookmarkErrorState('Failed to load bookmarks: $e'));
    }
  }

  Future<void> _onToggle(
      ToggleBookmarkEvent event, Emitter<BookmarkState> emit) async {
    try {
      final paper = event.paper;
      final index = _bookmarks.indexWhere((p) => p.paperId == paper.paperId);
      if (index >= 0) {
        _bookmarks.removeAt(index);
      } else {
        _bookmarks.add(paper);
      }
      emit(BookmarkLoadedState(List.from(_bookmarks)));
    } catch (e) {
      emit(BookmarkErrorState('Failed to toggle bookmark: $e'));
    }
  }
}
