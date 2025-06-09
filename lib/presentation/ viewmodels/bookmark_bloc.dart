import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/PaperModel.dart';

// Events
abstract class BookmarkEvent {}

class FetchBookmarksEvent extends BookmarkEvent {}

class ToggleBookmarkEvent extends BookmarkEvent {
  final PaperModel paper;
  ToggleBookmarkEvent(this.paper);
}

// States
abstract class BookmarkState {}

class BookmarkLoadingState extends BookmarkState {}

class BookmarkLoadedState extends BookmarkState {
  final List<PaperModel> papers;
  BookmarkLoadedState(this.papers);
}

class BookmarkErrorState extends BookmarkState {
  final String message;
  BookmarkErrorState(this.message);
}

// Bloc
class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  List<PaperModel> _bookmarkedPapers = [];

  BookmarkBloc() : super(BookmarkLoadingState()) {
    on<FetchBookmarksEvent>((event, emit) {
      emit(BookmarkLoadingState());
      emit(BookmarkLoadedState(_bookmarkedPapers));
    });

    on<ToggleBookmarkEvent>((event, emit) {
      if (_bookmarkedPapers.contains(event.paper)) {
        _bookmarkedPapers.remove(event.paper);
      } else {
        _bookmarkedPapers.add(event.paper);
      }
      emit(BookmarkLoadedState(List.from(_bookmarkedPapers)));
    });
  }
}
