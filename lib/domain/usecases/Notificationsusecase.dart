import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class NotificationsUseCase {
  final NotificationRepository repository;

  NotificationsUseCase(this.repository);

  
  Future<List<NotificationEntity>> getUserNotifications() {
    return repository.getUserNotifications();
  }

  Future<void> createNotification(String title, String message) {
    return repository.createNotification(title, message);
  }

  
  Future<void> notifyNewPaper() {
    return repository.notifyNewPaper();
  }

  
  Future<void> notifyInactiveUsers() {
    return repository.notifyInactiveUsers();
  }
}

