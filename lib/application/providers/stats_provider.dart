// lib/providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/stats_remote_data_source.dart';
import '../../data/repositories_impl/stats_repository_impl.dart';
import "../../domain/usecases/get_stats_usecase.dart";
import '../../presentation/ viewmodels/admin_stats_viewmodel.dart';

/// 1) Low-level HTTP client
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// 2) Remote data source
final statsRemoteDataSourceProvider =
    Provider<StatsRemoteDataSourceImpl>((ref) {
  final client = ref.watch(httpClientProvider);
  return StatsRemoteDataSourceImpl(client: client);
});

/// 3) Repository
final statsRepositoryProvider = Provider<StatsRepositoryImpl>((ref) {
  final ds = ref.watch(statsRemoteDataSourceProvider);
  return StatsRepositoryImpl(ds);
});

/// 4) Use case
final getStatsUseCaseProvider = Provider<GetStatsUseCase>((ref) {
  final repo = ref.watch(statsRepositoryProvider);
  return GetStatsUseCase(repo);
});

/// 5) ViewModel (ChangeNotifier)
final adminStatsViewModelProvider =
    ChangeNotifierProvider<AdminStatsViewModel>((ref) {
  final useCase = ref.watch(getStatsUseCaseProvider);
  return AdminStatsViewModel(useCase);
});
