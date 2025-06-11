import 'package:dio/dio.dart';
import '../models/stats_model.dart';

abstract class StatsRemoteDataSource {
  Future<StatsModel> fetchStats();
}

class StatsRemoteDataSourceImpl implements StatsRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  StatsRemoteDataSourceImpl({
    required this.dio,
    this.baseUrl = 'http://localhost:3500/api',
  });

  @override
  Future<StatsModel> fetchStats() async {
    try {
      final response = await dio.get('$baseUrl/admin/stats');

      if (response.statusCode == 200) {
        final data = response.data;
        return StatsModel.fromJson(data['stats']);
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load stats: $e');
    }
  }
}
