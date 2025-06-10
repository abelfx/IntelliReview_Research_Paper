import 'package:flutter/material.dart';
import '../../domain/usecases/get_stats_usecase.dart';
import '../../domain/entities/stats.dart';

class AdminStatsViewModel extends ChangeNotifier {
  final GetStatsUseCase getStatsUseCase;

  AdminStatsViewModel(this.getStatsUseCase);

  Stats? _stats;
  Stats? get stats => _stats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stats = await getStatsUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
