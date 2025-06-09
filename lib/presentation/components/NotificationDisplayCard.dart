import 'package:flutter/material.dart';
import 'package:frontend/data/models/notification_model.dart';
import 'package:frontend/domain/entities/notification_entity.dart';
import 'package:intl/intl.dart'; 

class NotificationDisplayCard extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationDisplayCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy – hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Optionally include image/avatar here

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _formatDate(notification.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
