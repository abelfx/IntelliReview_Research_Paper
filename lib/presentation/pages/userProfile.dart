import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/providers/user_provider.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  void _pickImage() async {
    // Stub for image picker
  }

  @override
  Widget build(BuildContext context) {
   final user = ref.watch(currentUserProvider);
final name = user?.name ?? 'Chaltu Nakew';
final email = user?.email ?? 'Chattuvegondar@gmail.com';
final role = user?.role ?? 'user';
final country = user?.country ?? 'Addis Ababa_Ethiopia';


    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 83, 100, 198),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: const Color.fromARGB(255, 83, 100, 198),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child:
                        const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  country,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          SizedBox(
            height: 40,
          ),
          Container(
            color: const Color(0x100E83),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('4.7', 'Avg rates', Icons.star, Colors.orange),
                _buildStatItem('50+', 'Comments', Icons.comment, Colors.blue),
                _buildStatItem('10+', 'Posts', Icons.post_add, Colors.green),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Text(
              'Recent posts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildPostItem(
            'What is the mathematical equation required to be good guy',
          ),
          _buildPostItem(
            'What is the mathematical equation required to be good guy',
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildStatItem(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.purple[50], // Light purple background
        borderRadius: BorderRadius.circular(20), // Rounded corners
        border: Border.all(
          color: const Color.fromARGB(255, 34, 13, 141)
              .withOpacity(0.3), // Light purple border
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white, // White circle background
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(102, 116, 48, 129)
                        .withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: Colors.purple[800], // Dark purple icon
                ),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800], // Dark purple text
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.purple[600], // Medium purple text
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Read',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
