import '../entities/stats.dart';
import '../repositories/stats_repository.dart';

class GetStatsUseCase {
  final StatsRepository repository;
  GetStatsUseCase(this.repository);

  Future<Stats> call() {
    return repository.getStats();
  }
}
