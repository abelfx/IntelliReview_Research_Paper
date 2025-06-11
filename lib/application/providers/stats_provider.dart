import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:frontend/presentation/%20viewmodels/admin_stats_viewmodel.dart';

import '../../data/datasources/stats_remote_data_source.dart';
import '../../data/repositories_impl/stats_repository_impl.dart';
import '../../domain/usecases/get_stats_usecase.dart';


/// 1) Dio client provider
final dioClientProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: 'http://localhost:3500/api',
    headers: {'Content-Type': 'application/json'},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
});

/// 2) Remote data source (Dio)
final statsRemoteDataSourceProvider = Provider<StatsRemoteDataSourceImpl>((ref) {
  final dio = ref.watch(dioClientProvider);
  return StatsRemoteDataSourceImpl(dio: dio);
});

/// 3) Repository
final statsRepositoryProvider = Provider<StatsRepositoryImpl>((ref) {
  final dataSource = ref.watch(statsRemoteDataSourceProvider);
  return StatsRepositoryImpl(dataSource);
});

/// 4) Use case
final getStatsUseCaseProvider = Provider<GetStatsUseCase>((ref) {
  final repository = ref.watch(statsRepositoryProvider);
  return GetStatsUseCase(repository);
});

/// 5) ViewModel (ChangeNotifier)
final adminStatsViewModelProvider = ChangeNotifierProvider<AdminStatsViewModel>((ref) {
  final useCase = ref.watch(getStatsUseCaseProvider);
  return AdminStatsViewModel(useCase);
});
