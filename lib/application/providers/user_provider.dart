import 'package:frontend/data/datasources/Userdatasource.dart';
import 'package:frontend/data/models/Usermodel.dart';
import 'package:frontend/data/repositories_impl/Userrepositoriesimpl.dart';
import 'package:frontend/domain/usecases/Userusecase.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataSourceProvider = Provider<UserDataSource>((ref) {
  return UserDataSource();
});

final userRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return Userrepositoriesimpl(userDataSource: dataSource);
});
final userRoleProvider = StateProvider<String?>((ref) => null);
final currentUserProvider = StateProvider<Usermodel?>((ref) => null);

final userUseCaseProvider = Provider((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return Userusecase(userRepository: repo);


});
