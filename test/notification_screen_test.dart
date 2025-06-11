import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/application/providers/notification_provider.dart';
import 'package:frontend/domain/entities/notification_entity.dart';
import 'package:frontend/presentation/pages/notification_screen.dart';
import 'package:frontend/presentation/ viewmodels/notification_stateNotification.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationNotifier extends Mock implements NotificationNotifier {
  @override
  bool get isLoading => true;
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
    await tester.pumpWidget(createTestWidget(const NotificationScreen()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message on error state', (tester) async {
    when(() => mockNotifier.getUserNotifications())
        .thenThrow(Exception('Network error'));

    await tester.pumpWidget(createTestWidget(const NotificationScreen()));
    expect(find.textContaining('Error: Network error'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('displays list of notifications when data is loaded',
      (tester) async {
    final mockNotifications = [
      NotificationEntity(
          id: '1',
          title: 'Test',
          message: 'Message',
          createdAt: DateTime.now()),
    ];

    when(() => mockNotifier.getUserNotifications())
        .thenAnswer((_) async => mockNotifications);

    await tester.pumpWidget(createTestWidget(const NotificationScreen()));
    await tester.pump(); // for any async building

    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Message'), findsOneWidget);
  });

  testWidgets('creates notification on button tap', (tester) async {
    when(() => mockNotifier.createNotification(any(), any()))
        .thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget(const NotificationScreen()));

    await tester.enterText(find.byType(TextField).at(0), 'New Title');
    await tester.enterText(find.byType(TextField).at(1), 'New Message');

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    verify(() => mockNotifier.createNotification('New Title', 'New Message'))
        .called(1);
  });
}
