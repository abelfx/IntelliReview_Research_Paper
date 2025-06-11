import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/pages/adminDashboard.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:frontend/application/providers/nav_provider.dart';
import 'package:frontend/presentation/components/app_bottom_nav_bar.dart';
import 'package:frontend/model/PaperModel.dart';

// Screens
import 'package:frontend/presentation/pages/Hompage.dart';
import 'package:frontend/presentation/pages/bookmark.dart';
import 'package:frontend/presentation/pages/commentingpage.dart';
import 'package:frontend/presentation/pages/notification_screen.dart';
import 'package:frontend/presentation/pages/posting.dart';
import 'package:frontend/presentation/pages/userProfile.dart';
import 'package:frontend/presentation/pages/categoryview.dart';
import 'package:frontend/presentation/pages/createCatagory.dart';
import 'package:frontend/presentation/pages/login_screen.dart';
import 'package:frontend/presentation/pages/signup_screen.dart';
import 'package:frontend/presentation/pages/welcome_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final role = ref.read(userRoleProvider);
      final isLoggedIn = role != null;
      final isAuthPage = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/welcome';

      if (!isLoggedIn) {
        // If not logged in and trying to access a protected page
        if (!isAuthPage && state.matchedLocation != '/') {
          return '/viewcategory';
        }
        return null;
      }

      // If logged in and trying to access auth pages, redirect to appropriate home
      if (isAuthPage) {
        return role == 'admin' ? '/admin' : '/home';
      }

      // For admin users, ensure they can't access user home
      if (role == 'admin' && state.matchedLocation == '/home') {
        return '/admin';
      }

      return null; // No redirection
    },
    debugLogDiagnostics: true,
    routes: [
      /// Auth and landing routes
      GoRoute(
        path: '/',
        builder: (context, state) => CategoryViewScreen()
        //  onLoginClick: () => context.go('/login'),
         // onSignUpClick: () => context.go('/signup'),
       // ),
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

      /// Shell for nav-bar pages (scaffold wraps these)
      ShellRoute(
        builder: (context, state, child) {
          return Consumer(
            builder: (context, ref, _) {
              final currentIndex = ref.watch(navIndexProvider);
              final role = ref.watch(userRoleProvider) ?? 'user';

              return Scaffold(
                body: child,
                bottomNavigationBar: AppBottomNavBar(
                  selectedIndex: currentIndex,
                  role: role,
                  onItemSelected: (newIndex) {
                    ref.read(navIndexProvider.notifier).state = newIndex;
                    switch (newIndex) {
                      case 0:
                        context.go(role == 'admin' ? '/admin' : '/home');
                        break;
                      case 1:
                        context.go('/favourites');
                        break;
                      case 2:
                        context.go(role == 'admin'
                            ? '/createCategory'
                            : '/viewcategory');
                        break;
                      case 3:
                        context
                            .go(role == 'admin' ? '/notifications' : '/post');
                        break;
                      case 4:
                        context.go('/profile');
                        break;
                    }
                  },
                ),
              );
            },
          );
        },
        routes: [
          GoRoute(path: '/home', builder: (_, __) => HomeScreen()),
          GoRoute(
              path: '/favourites', builder: (_, __) => const BookmarkScreen()),
          GoRoute(
              path: '/viewcategory',
              builder: (_, __) => const CategoryViewScreen()),
          GoRoute(
              path: '/createCategory',
              builder: (_, __) => const CreateCategoryScreen()),
          GoRoute(
              path: '/notifications',
              builder: (_, __) => const NotificationScreen()),
          GoRoute(path: '/post', builder: (_, __) => const PostingScreen()),
          GoRoute(
              path: '/profile', builder: (_, __) => const UserProfileScreen()),
          GoRoute(path: '/admin', builder: (_, __) => AdminDashboard()),
        ],
      ),

      /// Standalone (non-shell) route with arguments
      GoRoute(
        path: '/commenting',
        builder: (context, state) {
          final paper = (state.extra is PaperModel)
              ? state.extra as PaperModel
              : PaperModel(
                  paperId: 'demo-id',
                  title: 'Demo Paper',
                  averageRating: 4.5,
                  pdfUrl: 'https://example.com/demo.pdf',
                  publishedDate: '2024-01-01',
                  authorName: 'Demo Author',
                  imageAsset: 'assets/avatar_placeholder.png',
                  category: 'Demo Category',
                  createdAt: DateTime.now(),
                );
          return CommentingPage(paper: paper);
        },
      ),
    ],
  );
});
