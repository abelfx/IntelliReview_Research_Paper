// lib/presentation/components/app_bottom_nav_bar.dart

import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final String role;

  const AppBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the destinations (you can use your GoRouter routes here)
    final labels = role == 'admin'
        ? ['Dashboard', 'Favourites', 'Add', 'Alerts', 'Profile']
        : ['Home', 'Favourites', 'Grid', 'Messages', 'Profile'];

    final icons = role == 'admin'
        ? [
            Icons.dashboard_outlined,
            Icons.favorite_border,
            Icons.add_outlined,
            Icons.notifications_active_outlined,
            Icons.person_outline,
          ]
        : [
            Icons.home_outlined,
            Icons.favorite_border,
            Icons.grid_view_outlined,
            Icons.send_outlined,
            Icons.person_outline,
          ];

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFECECFB),
      selectedItemColor: const Color(0xFF5D5CBB),
      unselectedItemColor: const Color(0xFF444444),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onItemSelected,
      items: List.generate(labels.length, (i) {
        return BottomNavigationBarItem(
          icon: Icon(icons[i], size: 26),
          label: labels[i],
        );
      }),
    );
  }
}
