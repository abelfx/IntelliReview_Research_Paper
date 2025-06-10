// (added updatePaper)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/paper_entity.dart';
import '../../domain/usecases/paper_usecase.dart';

enum PaperStatus { initial, loading, loaded, error }

class PaperState {
  final PaperStatus status;
  final List<PaperEntity> papers;
  final String? errorMessage;

  PaperState({
    required this.status,
    required this.papers,
    this.errorMessage,
  });

  factory PaperState.initial() =>
      PaperState(status: PaperStatus.initial, papers: [], errorMessage: null);

  PaperState copyWith({
    PaperStatus? status,
    List<PaperEntity>? papers,
    String? errorMessage,
  }) {
    return PaperState(
      status: status ?? this.status,
      papers: papers ?? this.papers,
      errorMessage: errorMessage,
    );
  }
}

class PaperNotifier extends StateNotifier<PaperState> {
  final PaperUseCase useCase;

  PaperNotifier(this.useCase) : super(PaperState.initial());

  Future<void> fetchPapers() async {
    state = state.copyWith(status: PaperStatus.loading, errorMessage: null);
    try {
      final papers = await useCase.viewPapers();
      state = state.copyWith(
        status: PaperStatus.loaded,
        papers: papers,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: PaperStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeUpdate(PaperState newState) {
    if (!_isDisposed) state = newState;
  }

  Future<void> deletePaper(String id) async {
    _safeUpdate(state.copyWith(status: PaperStatus.loading));

    try {
      await useCase.deletePaper(id);
      final updated = await useCase.viewPapers();
      _safeUpdate(state.copyWith(status: PaperStatus.loaded, papers: updated));
    } catch (e) {
      _safeUpdate(state.copyWith(
          status: PaperStatus.error, errorMessage: e.toString()));
    }
  }

  /// NEW: update title + authors, then refresh
  Future<void> updatePaper(
    String id,
    String title,
    List<String> authors,
  ) async {
    state = state.copyWith(status: PaperStatus.loading, errorMessage: null);
    try {
      await useCase.updatePaper(
          id, title, authors, /*year*/ 0, /*category*/ '', null);
      final updated = await useCase.viewPapers();
      state = state.copyWith(status: PaperStatus.loaded, papers: updated);
    } catch (e) {
      state = state.copyWith(
        status: PaperStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
