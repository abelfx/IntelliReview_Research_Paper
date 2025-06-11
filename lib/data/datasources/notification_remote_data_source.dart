import 'package:dio/dio.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSource(this.dio);

  Future<List<NotificationModel>> getUserNotifications() async {
    try {
      final response = await dio.get(
        'http://localhost:3500/api/notification/getAllNotification',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return List<NotificationModel>.from(
          data.map((n) => NotificationModel.fromJson(n)),
        );
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (error) {
      throw Exception('Error loading notifications: $error');
    }
  }

  Future<void> notifyNewPaper() async {
    try {
      final response = await dio.post(
        'https://localhost:5000/api/notification/new-paper',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to notify new paper');
      }
    } catch (error) {
      throw Exception('Error notifying new paper: $error');
    }
  }

  Future<void> notifyInactiveUsers() async {
    try {
      final response = await dio.post(
        'https:/localhost:5000/api/notification/inactive-users',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to notify inactive users');
      }
    } catch (error) {
      throw Exception('Error notifying inactive users: $error');
    }
  }

  Future<void> createNotification(String title, String message) async {
    try {
      final response = await dio.post(
        'http://localhost:3500/api/notification/createNotification',
        data: {
          'title': title,
          'message': message,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create notification');
      }
    } catch (error) {
      throw Exception('Error creating notification: $error');
    }
  }
}
