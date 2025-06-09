import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerContent extends StatefulWidget {
  final void Function() onLogout;
  final Function(String route) onNavigate;

  const DrawerContent({
    super.key,
    required this.onLogout,
    required this.onNavigate,
  });

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  String name = "Guest User";
  String email = "no email";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('KEY_NAME') ?? "Guest User";
      email = prefs.getString('KEY_EMAIL') ?? "no email";
    });
  }

  final List<_DrawerItem> items = [
    _DrawerItem(label: "Home", route: "/home", icon: Icons.home_outlined),
    _DrawerItem(label: "Profile", route: "/profile", icon: Icons.person_outline),
    _DrawerItem(label: "Bookmark", route: "/favourites", icon: Icons.favorite_border_outlined),
    _DrawerItem(label: "Create Category", route: "/createCategory", icon: Icons.grid_view_outlined),
    _DrawerItem(label: "View Category", route: "/grid", icon: Icons.grid_view_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 24, left: 16),
            color: const Color(0xFF5D5CBB),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/welcome_screen_container.png'), // Your image asset here
                ),
                const SizedBox(height: 12),
                Text(
                  name.isEmpty ? "Guest User" : name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  email.isEmpty ? "no email" : email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFE8E8ED),
              padding: const EdgeInsets.only(left: 16, top: 24, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...items.map(
                        (item) => InkWell(
                      onTap: () {
                        widget.onNavigate(item.route);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 23,
                              color: const Color(0xFF36454F),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              item.label,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF36454F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Divider(color: Colors.grey, indent: 0, endIndent: 16),
                  InkWell(
                    onTap: () {
                      widget.onLogout();
                      widget.onNavigate("/login"); // or however you handle login navigation
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.logout_outlined,
                            size: 23,
                            color: Color(0xFF36454F),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF36454F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final String label;
  final String route;
  final IconData icon;

  _DrawerItem({
    required this.label,
    required this.route,
    required this.icon,
  });
}
