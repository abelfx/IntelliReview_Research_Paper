import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/application/providers/notification_provider.dart';
import 'package:frontend/domain/entities/notification_entity.dart';
import 'package:frontend/presentation/%20viewmodels/notification_stateNotification.dart';
import 'package:frontend/presentation/components/NotificationDisplayCard.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // Set user ID if needed, e.g., from a user provider
      final userId = "sample-user-id"; // Replace with actual logic
      ref.read(notificationNotifierProvider.notifier).setUserId(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationNotifierProvider);
    final notifier = ref.read(notificationNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCreateForm(notifier),
            const SizedBox(height: 16),
            Expanded(
              child: notificationsAsync.when(
                data: (notifications) => ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return NotificationDisplayCard(notification: notification);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $e',
                          style: const TextStyle(color: Colors.red)),
                      ElevatedButton(
                        onPressed: notifier.getUserNotifications,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateForm(NotificationNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5D5CBB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Title",
              style: TextStyle(color: Colors.white, fontSize: 23)),
          const SizedBox(height: 8),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFE6E6FA),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Message",
              style: TextStyle(color: Colors.white, fontSize: 23)),
          const SizedBox(height: 8),
          TextField(
            controller: messageController,
            maxLines: 4,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFE6E6FA),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(190, 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await notifier.createNotification(
                  titleController.text,
                  messageController.text,
                );
                Fluttertoast.showToast(
                  msg: "Notification Created!",
                  toastLength: Toast.LENGTH_SHORT,
                );
                titleController.clear();
                messageController.clear();
              },
              child: const Text("Create",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
