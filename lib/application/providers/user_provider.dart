import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/datasources/Userdatasource.dart';
import 'package:frontend/data/models/Usermodel.dart';
import 'package:frontend/data/repositories_impl/Userrepositoriesimpl.dart';
import 'package:frontend/domain/usecases/Userusecase.dart';

/// 1) Dio Provider
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

/// 2) UserDataSource Provider — pass Dio instance
final userDataSourceProvider = Provider<UserDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return UserDataSource(dio);
});

/// 3) UserRepository Provider
final userRepositoryProvider = Provider<Userrepositoriesimpl>((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return Userrepositoriesimpl(userDataSource: dataSource);
});

/// 4) UserUseCase Provider
final userUseCaseProvider = Provider<Userusecase>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return Userusecase(userRepository: repo);
});

/// 5) User role state provider (nullable string)
final userRoleProvider = StateProvider<String?>((ref) => null);

/// 6) Current logged-in user state provider (nullable Usermodel)
final currentUserProvider = StateProvider<Usermodel?>((ref) => null);
