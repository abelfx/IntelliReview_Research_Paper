import '../../domain/entities/stats.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/stats_remote_data_source.dart';

class StatsRepositoryImpl implements StatsRepository {
  final StatsRemoteDataSource remoteDataSource;

  StatsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Stats> getStats() {
    return remoteDataSource.fetchStats();
  }
}
