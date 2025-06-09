import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String role;

  BottomNavBar({
    required this.selectedIndex,
    required this.onItemSelected,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final userItems = [
      _NavItem(Icons.home_outlined, 'home'),
      _NavItem(Icons.favorite_border, 'favorites'),
      _NavItem(Icons.grid_view_outlined, 'grid'),
      _NavItem(Icons.send_outlined, 'messages'),
      _NavItem(Icons.person_outline, 'profile'),
    ];

    final adminItems = [
      _NavItem(Icons.home_outlined, 'dashboard'),
      _NavItem(Icons.favorite_border, 'favorites'),
      _NavItem(Icons.add_outlined, 'create_category'),
      _NavItem(Icons.notifications_active_outlined, 'notifications'),
      _NavItem(Icons.person_outline, 'profile'),
    ];

    final items = role == 'admin' ? adminItems : userItems;

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFECECFB),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onItemSelected(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 26,
                  color: const Color(0xFF444444),
                ),
                const SizedBox(height: 4),
                isSelected
                    ? Container(
                  width: 24,
                  height: 2,
                  color: const Color(0xFF5D5CBB),
                )
                    : const SizedBox(height: 2),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String route;
  _NavItem(this.icon, this.route);
}
