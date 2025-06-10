import '../../domain/entities/stats.dart';

class StatsModel extends Stats {
  StatsModel({required int papers, required int users})
      : super(papers: papers, users: users);

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      papers: json['papers'] as int,
      users: json['users'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'papers': papers,
      'users': users,
    };
  }
}
