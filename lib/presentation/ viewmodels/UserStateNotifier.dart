
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:frontend/domain/usecases/Userusecase.dart';
import 'package:riverpod/riverpod.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class UserNotifier extends StateNotifier<AuthStatus> {
  final Userusecase userUsecase;

  UserNotifier(this.userUsecase) : super(AuthStatus.initial);

 

  Future<void> login(String email, String password, WidgetRef ref) async {
  state = AuthStatus.loading;
  try {
    final result = await userUsecase.login(email, password);
    final role = result['user']['role']; // assumes backend returns role

    // Set the role in the provider
    ref.read(userRoleProvider.notifier).state = role;

    state = AuthStatus.authenticated;
  } catch (e) {
    state = AuthStatus.error;
  }
}

Future<void> signup(String name, String email, String password, String country, String role, WidgetRef ref) async {
  state = AuthStatus.loading;
  try {
    await userUsecase.signup(name, email, password, country, role);

    // Set the role in the provider
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
