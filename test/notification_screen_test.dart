import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/application/providers/notification_provider.dart';
import 'package:frontend/domain/entities/notification_entity.dart';
import 'package:frontend/presentation/pages/notification_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/presentation/ viewmodels/notification_stateNotification.dart';

// Mock class for NotificationNotifier
class MockNotificationNotifier extends Mock implements NotificationNotifier {
  // No need to define methods here; mocktail will handle it
}

void main() {
  late MockNotificationNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockNotificationNotifier();
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        notificationNotifierProvider.overrideWith((ref) => mockNotifier),
      ],
      child: MaterialApp(home: child),
    );
  }

  testWidgets('shows loading indicator when loading', (tester) async {
    // Simulate loading state
    when(() => mockNotifier.getUserNotifications())
        .thenAnswer((_) async => null);

    await tester.pumpWidget(createTestWidget(const NotificationScreen()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message on error state', (tester) async {
    // Simulate error state
    when(() => mockNotifier.getUserNotifications())
        .thenThrow(Exception('Network error'));

    await tester.pumpWidget(createTestWidget(const NotificationScreen()));
    expect(find.textContaining('Error: Network error'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('displays list of notifications when data is loaded',
      (tester) async {
    // Create mock notifications
    final mockNotifications = [
      NotificationEntity(
        id: '1',
        title: 'Test',
        message: 'Message',
        createdAt: DateTime.now(),
      ),
    ];

    // Simulate loaded state
    when(() => mockNotifier.getUserNotifications())
        .thenAnswer((_) async => mockNotifications);

    await tester.pumpWidget(createTestWidget(const NotificationScreen()));
    await tester.pump(); // for any async building

    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Message'), findsOneWidget);
  });

  testWidgets('creates notification on button tap', (tester) async {
    // Simulate initial state with no notifications
    when(() => mockNotifier.getUserNotifications()).thenAnswer((_) async => []);
    when(() => mockNotifier.createNotification(any(), any()))
        .thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget(const NotificationScreen()));

    // Simulate entering text in the title and message fields
    await tester.enterText(find.byType(TextField).at(0), 'New Title');
    await tester.enterText(find.byType(TextField).at(1), 'New Message');

    // Simulate tapping the create button
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    // Verify that the createNotification method was called with the correct arguments
    verify(() => mockNotifier.createNotification('New Title', 'New Message'))
        .called(1);
  });
}
