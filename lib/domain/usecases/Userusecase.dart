import 'package:frontend/domain/entities/Userentities.dart';
import 'package:frontend/domain/repositories/Userrepositories.dart';

class Userusecase {
  final Userrepositories userRepository;

  Userusecase({required this.userRepository});

  Future<void> signup(
    String name,
    String email,
    String password,
    String country,
    String role,
  ) {
    return userRepository.signup(
      name,
      email,
      password,
      country,
      role,
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) {
    return userRepository.login(email, password);
  }
}
