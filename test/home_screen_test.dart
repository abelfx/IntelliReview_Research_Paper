import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/pages/Hompage.dart';
import 'package:frontend/domain/entities/paper_entity.dart';
import 'package:frontend/presentation/ viewmodels/PaperNotifier.dart';
import 'package:frontend/application/providers/paper_provider.dart';
import 'package:frontend/domain/usecases/paper_usecase.dart';
import 'package:frontend/domain/repositories/paper_repository.dart';

class MockPaperNotifier extends PaperNotifier {
  MockPaperNotifier()
      : super(MockPaperUseCase(repository: MockPaperRepository()));

  @override
  Future<void> fetchPapers() async {
    // Simulate fetching papers
    state = state.copyWith(
      status: PaperStatus.loaded,
      papers: [
        PaperEntity(
          id: '1',
          title: 'AI Research',
          authors: ['John Doe'],
          year: 2024,
          pdfUrl: 'https://example.com/ai.pdf',
          uploadedBy: "author",
          category: "maths",
        ),
      ],
    );
  }
}

// Mock implementation of PaperRepository for testing
class MockPaperRepository implements PaperRepository {
  @override
  Future<PaperEntity> uploadPaper(
    String title,
    List<String> authors,
    int year,
    String uploadedBy,
    String category,
    String filePath,
  ) async {
    // Mock upload behavior if needed
    return PaperEntity(
      id: '2', // Mock ID
      title: title,
      authors: authors,
      year: year,
      pdfUrl: filePath, // Assuming filePath is the URL
      uploadedBy: uploadedBy,
      category: category,
    );
  }

  @override
  Future<PaperEntity> updatePaper(
    String id,
    String title,
    List<String> authors,
    int year,
    String category,
    String? filePath,
  ) async {
    // Mock update behavior if needed
    return PaperEntity(
      id: id,
      title: title,
      authors: authors,
      year: year,
      pdfUrl: filePath ?? '', // Ensure non-null value
      uploadedBy: "author",
      category: category,
    );
  }

  @override
  Future<List<PaperEntity>> viewPapers() async {
    return [
      PaperEntity(
        id: '1',
        title: 'AI Research',
        authors: ['John Doe'],
        year: 2024,
        pdfUrl: 'https://example.com/ai.pdf',
        uploadedBy: "author",
        category: "maths",
      ),
    ];
  }

  @override
  Future<void> deletePaper(String id) async {
    // Mock delete behavior if needed
  }
}

// Mock implementation of PaperUseCase for testing
class MockPaperUseCase extends PaperUseCase {
  MockPaperUseCase({required PaperRepository repository})
      : super(
            repository:
                repository); // Pass the mock repository as a named parameter

  @override
  Future<List<PaperEntity>> viewPapers() async {
    return await repository.viewPapers(); // Use the mock repository
  }

  @override
  Future<void> deletePaper(String id) async {
    // Mock delete behavior if needed
  }

  @override
  Future<PaperEntity> updatePaper(String id, String title, List<String> authors,
      int year, String category, String? pdfUrl) async {
    // Mock update behavior if needed
    return PaperEntity(
      id: id,
      title: title,
      authors: authors,
      year: year,
      pdfUrl: pdfUrl ?? '', // Ensure non-null value
      uploadedBy: "author",
      category: category,
    );
  }
}

void main() {
  testWidgets('HomeScreen UI and search behavior test',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paperNotifierProvider.overrideWith((ref) => MockPaperNotifier()),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Simulate fetching papers
    await tester.pumpAndSettle();

    // Check TopBar text
    expect(find.text('IntelliReview'), findsOneWidget);

    // Check paper title appears
    expect(find.text('AI Research'), findsOneWidget);

    // Search for something that doesn't exist
    await tester.enterText(find.byType(TextField), 'Quantum Computing');
    await tester.pumpAndSettle();

    // Should now show "No papers found"
    expect(find.text('No papers found'), findsOneWidget);
  });
}
