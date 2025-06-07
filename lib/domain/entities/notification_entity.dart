class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String? userId;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    this.userId,
    required this.createdAt,
  });
}
