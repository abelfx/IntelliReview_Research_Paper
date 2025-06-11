import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:frontend/presentation/pages/login_screen.dart';
import 'package:frontend/presentation/pages/signup_screen.dart';

void main() {
  testWidgets('Login and Signup navigation works as expected', (tester) async {
    final container = ProviderContainer(overrides: [
      userRoleProvider.overrideWith((ref) => null),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Expect to be on WelcomeScreen
    expect(find.text('Welcome'), findsOneWidget);

    // Tap on login button
    final loginButton = find.byKey(const Key('login_button'));
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Expect login screen
    expect(find.byType(LoginScreen), findsOneWidget);

    // Tap on "Sign Up" button from login screen
    final switchToSignUpButton = find.byKey(const Key('signup_switch_button'));
    expect(switchToSignUpButton, findsOneWidget);
    await tester.tap(switchToSignUpButton);
    await tester.pumpAndSettle();

    // Expect SignUp screen
    expect(find.byType(SignUpScreen), findsOneWidget);
  });

  testWidgets('User role redirects to proper dashboard', (tester) async {
    // Role is "admin"
    final container = ProviderContainer(overrides: [
      userRoleProvider.overrideWith((ref) => 'admin'),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Should go to /admin automatically
    expect(find.text('Admin Dashboard'), findsOneWidget);
  });
}
