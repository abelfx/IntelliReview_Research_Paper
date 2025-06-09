import 'package:flutter/foundation.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String? userId;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.userId,
    required this.createdAt,
  }) : super(
          id: id,
          title: title,
          message: message,
          userId: userId,
          createdAt: createdAt,
        );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? json['id'] ?? "",
      title: json['title'] ?? "",
      message: json['message'] ?? "",
      userId: json['userId'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
        if (userId != null) 'userId': userId,
      };
}
