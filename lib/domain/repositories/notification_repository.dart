import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getUserNotifications(String userId);
  Future<void> notifyNewPaper();
  Future<void> notifyInactiveUsers();
  Future<void> createNotification(String title, String message);
}
