
import 'package:frontend/domain/entities/notification_entity.dart';
import 'package:frontend/domain/usecases/Notificationsusecase.dart';
import 'package:riverpod/riverpod.dart';
class NotificationNotifier extends StateNotifier<AsyncValue<List<NotificationEntity>>> {
  final NotificationsUseCase notificationUseCase;

  NotificationNotifier(this.notificationUseCase) : super(const AsyncLoading()) {
    getUserNotifications(); // Call this during initialization if userId is known
  }

  String? _userId;

  void setUserId(String userId) {
    _userId = userId;
    getUserNotifications(); // Refresh when userId is set
  }

  Future<void> getUserNotifications() async {
    if (_userId == null) return;

    state = const AsyncLoading();
    try {
      final notifications = await notificationUseCase.getUserNotifications(_userId!);
      state = AsyncData(notifications);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> createNotification(String title, String message) async {
    try {
      await notificationUseCase.createNotification(title, message);
      await getUserNotifications(); // Optionally refresh list
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> notifyNewPaper() async {
    try {
      await notificationUseCase.notifyNewPaper();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> notifyInactiveUsers() async {
    try {
      await notificationUseCase.notifyInactiveUsers();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
