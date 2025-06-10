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

      // Debug print
      print('📊 Total papers fetched: ${papers.length}');
      for (var paper in papers) {
        print('📄 Paper: ${paper.title}, by ${paper.authors.join(', ')}');
      }

      state = state.copyWith(
        status: PaperStatus.loaded,
        papers: papers,
        errorMessage: null,
      );

      // Debug print after state update
      print('🔄 State updated to loaded with ${state.papers.length} papers');
    } catch (e) {
      print('❌ Error fetching papers: $e');
      state = state.copyWith(
        status: PaperStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> deletePaper(String id) async {
    state = state.copyWith(status: PaperStatus.loading, errorMessage: null);
    try {
      await useCase.deletePaper(id);
      // after delete, re-fetch list
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
