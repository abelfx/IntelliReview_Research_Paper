// lib/application/providers/notification_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:frontend/presentation/%20viewmodels/notification_stateNotification.dart';
import 'package:frontend/data/datasources/notification_remote_data_source.dart';
import 'package:frontend/data/repositories_impl/notification_repository_impl.dart';
import 'package:frontend/domain/usecases/Notificationsusecase.dart';
import 'package:frontend/domain/entities/notification_entity.dart';

/// 1. Dio Client Provider
final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio();

  // Optional: set base options, interceptors, headers here
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  return dio;
});

/// 2. Remote Data Source Provider
final notificationRemoteDataSourceProvider = Provider<NotificationRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return NotificationRemoteDataSource(dio);
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
