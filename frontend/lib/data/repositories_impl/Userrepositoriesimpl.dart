import 'package:frontend/data/datasources/Userdatasource.dart';
import 'package:frontend/domain/entities/Userentities.dart';
import 'package:frontend/domain/repositories/Userrepositories.dart';

class Userrepositoriesimpl implements Userrepositories {
  final UserDataSource userDataSource;
  Userrepositoriesimpl({required this.userDataSource});

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    String country,
    String role,
  ) async {
    return await userDataSource.signup(
      name: name,
      email: email,
      password: password,
      country: country,
      role: role,
    );
  }

  @override
  Future<Map<String, dynamic>> login(email, password) async {
    return await userDataSource.login(email, password);
  }
}
