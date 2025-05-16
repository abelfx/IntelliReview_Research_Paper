import 'package:flutter/foundation.dart';
import 'package:frontend/data/datasources/Categorydatasource.dart';
import 'package:frontend/data/repositories_impl/Categoryrepositoriesimpl.dart';
import 'package:frontend/domain/usecases/Categoryusecase.dart';
import 'package:riverpod/riverpod.dart';

final categoryDataSourceProvider = Provider<CategoryDataSource>((ref) {
  return CategoryDataSource();
});

final categoryRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(categoryDataSourceProvider);
  return Categoryrepositoriesimpl(categoryDataSource: dataSource);
});

final categoryUseCaseProvider = Provider((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return Categoryusecase(categoryRepository: repo);
});