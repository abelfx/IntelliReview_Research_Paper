// File: lib/ui/screens/user_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String name = '';
  String email = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    _loadUserPrefs();
  }

  Future<void> _loadUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('KEY_NAME') ?? '';
      email = prefs.getString('KEY_EMAIL') ?? '';
      role = prefs.getString('KEY_ROLE') ?? '';
    });
  }

  void _pickImage() async {
    // Stub for image picker
  }

  @override
  Widget build(BuildContext context) {
    final displayName = name.isNotEmpty ? name : 'Guest User';
    final displayEmail = email.isNotEmpty ? email : 'No email';
    final displayRole = role.isNotEmpty ? role[0].toUpperCase() + role.substring(1) : 'User';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage('assets/ic_launcher_foreground.png'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(displayName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(displayEmail,
                    style: TextStyle(color: Colors.white.withOpacity(0.8))),
                const SizedBox(height: 4),
                Text(displayRole,
                    style: TextStyle(color: Colors.white.withOpacity(0.8))),
                const SizedBox(height: 16),
                Container(
                  color: const Color(0xFF5D5CBB),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      UserStat(icon: Icons.star, value: '0.0', label: 'Avg rates'),
                      UserStat(icon: Icons.comment, value: '0', label: 'Comments'),
                      UserStat(icon: Icons.post_add, value: '0', label: 'Posts'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Recent posts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text('No recent posts',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          ),
          const SizedBox(height: 32),
          // Example of a research paper card:
          // ResearchPaperCard(...),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class UserStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const UserStat({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Icon(icon, size: 16, color: Colors.orange),
          const SizedBox(width: 4),
          Text(value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ]);
  }
}
