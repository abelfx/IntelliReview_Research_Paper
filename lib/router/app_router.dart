import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:frontend/presentation/pages/bookmark.dart';
import 'package:frontend/presentation/pages/commentingpage.dart';
import 'package:frontend/presentation/pages/notification_screen.dart';
import 'package:frontend/presentation/pages/posting.dart';
import 'package:frontend/presentation/pages/userProfile.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/Hompage.dart';
import 'package:frontend/presentation/pages/categoryview.dart';
import 'package:frontend/presentation/pages/createCatagory.dart';
import 'package:frontend/presentation/pages/login_screen.dart';
import 'package:frontend/presentation/pages/signup_screen.dart';
import 'package:frontend/presentation/pages/welcome_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final role = ref.watch(userRoleProvider);
      final isLoggedIn = role != null;
      final isAuthPage = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';
      final currentLocation = state.matchedLocation;
      // If not logged in and not on auth/welcome page, redirect to welcome
      // 1. Guest (unauthenticated) logic
      if (!isLoggedIn) {
        // Allow access to auth/welcome pages
        if (currentLocation == '/' ||
            currentLocation == '/login' ||
            currentLocation == '/signup') {
          return null;
        }
        // Redirect all other pages to welcome
        return '/';
      }

      // 3. User logic
      if (role == 'user') {
        return '/viewcategory';
      } else if (role == 'admin') {
        return '/createCategory';
      } else {
        // Allow access to user routes
        return null;
      }

      // Fallback (shouldn't normally reach here)
    },
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => WelcomeScreen(
          onLoginClick: () => context.go('/login'),
          onSignUpClick: () => context.go('/signup'),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            LoginScreen(onSignUpClick: () => context.go('/signup')),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) =>
            SignUpScreen(onLoginClick: () => context.go('/login')),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/viewcategory',
        builder: (context, state) => const CategoryViewScreen(),
      ),
      GoRoute(
        path: '/createCategory',
        builder: (context, state) => const CreateCategoryScreen(),
      ),
      GoRoute(
        path: '/Profilepage',
        builder: (context, state) => const UserProfileScreen(),
      ),
      //Notificationpage
      GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    ],
    debugLogDiagnostics: true, // Helpful for debugging routing issues
  );
});
