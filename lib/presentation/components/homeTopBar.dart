import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuClick;
  final String inputName;
  final VoidCallback onNotificationClick;

  const HomeTopBar({
    super.key,
    required this.onMenuClick,
    required this.inputName,
    required this.onNotificationClick,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onMenuClick,
                icon: Icon(
                  Icons.menu,
                  color: Color(0xFF36454F),
                  size: 28,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                inputName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF36454F),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onNotificationClick,
            icon: Icon(
              Icons.notifications_outlined,
              color: Color(0xFF36454F),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
