
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:frontend/data/models/Usermodel.dart';
import 'package:frontend/domain/usecases/Userusecase.dart';
import 'package:riverpod/riverpod.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class UserNotifier extends StateNotifier<AuthStatus> {
  final Userusecase userUsecase;

  UserNotifier(this.userUsecase) : super(AuthStatus.initial);

 

  Future<void> login(String email, String password,WidgetRef ref) async {
    state = AuthStatus.loading;
    try {
      final result = await userUsecase.login(email, password);
      final userMap = result['user'];
      final userModel = Usermodel.fromjson(userMap);
      
      // Update providers
      ref.read(currentUserProvider.notifier).state = userModel;
      ref.read(userRoleProvider.notifier).state = userModel.role;
      
      state = AuthStatus.authenticated;
    } catch (e) {
      state = AuthStatus.error;
      rethrow; // Consider rethrowing to handle in UI
    }
  }

Future<void> signup(String name, String email, String password, String country, String role, WidgetRef ref) async {
  state = AuthStatus.loading;
  try {
    final userMap = await userUsecase.signup(name, email, password, country, role);
    final userModel = Usermodel.fromjson(userMap); // Ensure this exists

    ref.read(currentUserProvider.notifier).state = userModel;
    ref.read(userRoleProvider.notifier).state = role;

    state = AuthStatus.authenticated;
  } catch (e) {
    state = AuthStatus.error;
  }
}


}

final userNotifierProvider = StateNotifierProvider<UserNotifier, AuthStatus>((ref) {
  final useCase = ref.watch(userUseCaseProvider);
  return UserNotifier(useCase);
});