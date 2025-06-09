import 'package:frontend/domain/repositories/notification_repository.dart';

import '../../domain/entities/notification_entity.dart';

import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getUserNotifications() {
    return remoteDataSource.getUserNotifications();
  }

  @override
  Future<void> notifyNewPaper() {
    return remoteDataSource.notifyNewPaper();
  }

  @override
  Future<void> notifyInactiveUsers() {
    return remoteDataSource.notifyInactiveUsers();
  }

  @override
  Future<void> createNotification(String title, String message) {
    return remoteDataSource.createNotification(title, message);
  }
}
