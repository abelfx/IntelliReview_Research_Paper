import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../models/notification_model.dart';
import '../repository/notification_repository.dart';
import '../viewmodels/notification_viewmodel.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  late NotificationViewModel viewModel;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    viewModel = context.read<NotificationViewModel>();
    viewModel.fetchNotifications();

    
    Future.delayed(Duration.zero, () {
      setState(() {
        isAdmin = viewModel.getUserRole() == 'admin';
      });
    });

    viewModel.notificationCreated.listen((notification) {
      Fluttertoast.showToast(
        msg: "Notification '${notification.title}' created!",
        toastLength: Toast.LENGTH_SHORT,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isAdmin) _buildAdminForm(context),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<NotificationViewModel>(
                builder: (context, vm, child) {
                  switch (vm.state) {
                    case NotificationState.loading:
                      return const Center(child: CircularProgressIndicator());
                    case NotificationState.success:
                      return ListView.builder(
                        itemCount: vm.notifications.length,
                        itemBuilder: (context, index) {
                          final notification = vm.notifications[index];
                          return NotificationCard(notification: notification);
                        },
                      );
                    case NotificationState.error:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(vm.errorMessage, style: TextStyle(color: Colors.red)),
                            ElevatedButton(
                              onPressed: vm.fetchNotifications,
                              child: const Text("Retry"),
                            )
                          ],
                        ),
                      );
                    case NotificationState.idle:
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5D5CBB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Title", style: TextStyle(color: Colors.white, fontSize: 23)),
          const SizedBox(height: 8),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFE6E6FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Message", style: TextStyle(color: Colors.white, fontSize: 23)),
          const SizedBox(height: 8),
          TextField(
            controller: messageController,
            maxLines: 4,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFE6E6FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
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
              onPressed: () {
                viewModel.createNotification(
                  titleController.text,
                  messageController.text,
                );
                titleController.clear();
                messageController.clear();
              },
              child: const Text("Create", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
 