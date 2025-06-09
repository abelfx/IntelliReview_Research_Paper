import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final http.Client client;

  NotificationRemoteDataSource(this.client);

  Future<List<NotificationModel>> getUserNotifications() async {
    final response = await client.get(
        Uri.parse('http://localhost:3500/api/notification/getAllNotification'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
   
      return List<NotificationModel>.from(
          data.map((n) => NotificationModel.fromJson(n)));
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> notifyNewPaper() async {
    final response = await client
        .post(Uri.parse('https://localhost:5000/api/notification/new-paper'));

    if (response.statusCode != 200) {
      throw Exception('Failed to notify new paper');
    }
  }

  Future<void> notifyInactiveUsers() async {
    final response = await client.post(
        Uri.parse('https:/localhost:5000/api/notification/inactive-users'));

    if (response.statusCode != 200) {
      throw Exception('Failed to notify inactive users');
    }
  }

  Future<void> createNotification(String title, String message) async {
    final response = await client.post(
      Uri.parse('http://localhost:3500/api/notification/createNotification'),
      body: jsonEncode({'title': title, 'message': message}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create notification');
    }
  }
}
