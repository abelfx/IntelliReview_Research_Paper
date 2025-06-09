import 'package:frontend/presentation/pages/Hompage.dart';
import 'package:frontend/presentation/pages/login_screen.dart';
import 'package:frontend/presentation/pages/signup_screen.dart';
import 'package:frontend/presentation/pages/welcome_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => WelcomeScreen(
        onLoginClick: () => context.go('/login'),
        onSignUpClick: () => context.go('/signup'),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Hompage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
  ],
);
