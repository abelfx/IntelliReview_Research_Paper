import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stats_model.dart';

abstract class StatsRemoteDataSource {
  Future<StatsModel> fetchStats();
}

class StatsRemoteDataSourceImpl implements StatsRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  StatsRemoteDataSourceImpl(
      {required this.client, this.baseUrl = 'http://localhost:3500/api'});

  @override
  Future<StatsModel> fetchStats() async {
    final response = await client.get(Uri.parse('$baseUrl/admin/stats'));
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return StatsModel.fromJson(jsonMap['stats']);
    } else {
      throw Exception('Failed to load stats: ${response.statusCode}');
    }
  }
}
