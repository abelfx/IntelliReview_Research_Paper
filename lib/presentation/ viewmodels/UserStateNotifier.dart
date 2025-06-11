import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:frontend/data/models/Usermodel.dart';
import 'package:frontend/domain/usecases/Userusecase.dart';
import 'package:frontend/router/app_router.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class UserNotifier extends StateNotifier<AuthStatus> {
  final Userusecase userUsecase;
  final Ref ref;

  UserNotifier(this.userUsecase, this.ref) : super(AuthStatus.initial);

   Future<void> login(String email, String password) async {
    state = AuthStatus.loading;
    try {
      final result = await userUsecase.login(email, password);
      final userMap = result['user'];
      final userModel = Usermodel.fromjson(userMap);
      
      // Update providers
      ref.read(currentUserProvider.notifier).state = userModel;
      ref.read(userRoleProvider.notifier).state = userModel.role;
      
      state = AuthStatus.authenticated;
      
      // Navigate based on role
      final router = ref.read(appRouterProvider);
      if (userModel.role == 'admin') {
        router.go('/admin');
      } else {
        router.go('/home');
      }
    } catch (e) {
      state = AuthStatus.error;
      rethrow;
    }
  }

  // Similar modification for signup
  Future<void> signup(String name, String email, String password, 
      String country, String role) async {
    state = AuthStatus.loading;
    try {
      final userMap = await userUsecase.signup(name, email, password, country, role);
      final userModel = Usermodel.fromjson(userMap);

      ref.read(currentUserProvider.notifier).state = userModel;
      ref.read(userRoleProvider.notifier).state = role;

      state = AuthStatus.authenticated;
      
      // Navigate based on role
      final router = ref.read(appRouterProvider);
      if (role == 'admin') {
        router.go('/admin');
      } else {
        router.go('/home');
      }
    } catch (e) {
      state = AuthStatus.error;
      rethrow;
    }
  }
}

final userNotifierProvider = StateNotifierProvider<UserNotifier, AuthStatus>((ref) {
  final useCase = ref.watch(userUseCaseProvider);
  return UserNotifier(useCase, ref);
});