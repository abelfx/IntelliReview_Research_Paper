import 'package:frontend/data/datasources/Userdatasource.dart';
import 'package:frontend/data/repositories_impl/Userrepositoriesimpl.dart';
import 'package:frontend/domain/usecases/Userusecase.dart';
import 'package:riverpod/riverpod.dart';

final userDataSourceProvider = Provider<UserDataSource>((ref) {
  return UserDataSource();
});

final userRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return Userrepositoriesimpl(userDataSource: dataSource);
});

final userUseCaseProvider = Provider((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return Userusecase(userRepository: repo);
});
