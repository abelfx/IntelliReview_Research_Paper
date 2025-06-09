// lib/application/providers/notification_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/%20viewmodels/notification_stateNotification.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/data/datasources/notification_remote_data_source.dart';
import 'package:frontend/data/repositories_impl/notification_repository_impl.dart';
import 'package:frontend/domain/usecases/Notificationsusecase.dart';
import 'package:frontend/domain/entities/notification_entity.dart';

/// 1. HTTP Client Provider
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

/// 2. Remote Data Source Provider
final notificationRemoteDataSourceProvider = Provider<NotificationRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return NotificationRemoteDataSource(client);
});

/// 3. Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepositoryImpl>((ref) {
  final remote = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remote);
});

/// 4. UseCase Provider
final notificationUseCaseProvider = Provider<NotificationsUseCase>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return NotificationsUseCase(repo);
});

/// 5. Notification Notifier Provider (StateNotifier)
final notificationNotifierProvider = StateNotifierProvider<NotificationNotifier, AsyncValue<List<NotificationEntity>>>((ref) {
  final useCase = ref.watch(notificationUseCaseProvider);
  return NotificationNotifier(useCase);
});
