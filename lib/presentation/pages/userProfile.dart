import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  File? _profileImage;
Uint8List? _webImage;

void _pickImage() async {
  final ImagePicker picker = ImagePicker();

  if (kIsWeb) {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _webImage = bytes;
      });
    }
  } else {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final name = user?.name ?? 'Chaltu Nakew';
    final email = user?.email ?? 'Chaltuvegondar@gmail.com';
    final role = user?.role ?? 'user';
    final country = user?.country ?? 'Addis Ababa, Ethiopia';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D5CBB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: const Color(0xFF5D5CBB),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Stack(
                  children: [
                 CircleAvatar(
  radius: 40,
  backgroundColor: Colors.grey[300],
  backgroundImage: _profileImage != null
      ? FileImage(_profileImage!)
      : (_webImage != null
          ? MemoryImage(_webImage!)
          : AssetImage('assets/images/profile_img.png') as ImageProvider),
),



                   Positioned(
  bottom: 0,
  right: 0,
  child: GestureDetector(
    onTap: _pickImage,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
    ),
  ),
),

                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      country,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: const Color(0xFF100E83),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('0.0', 'Avg rates', Icons.star, Colors.white),
                  _buildStatItem('0', 'Comments', Icons.comment, Colors.white),
                  _buildStatItem('0', 'Posts', Icons.post_add, Colors.white),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                'Recent posts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildPostItem(
            'What is the mathematical equation required to be good guy',
          ),
          const SizedBox(height: 8),
          _buildPostItem(
            'What is the mathematical equation required to be good guy',
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPostItem(String title) {
    return Card(
      color: const Color(0xFF5D5CBB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.image, size: 30, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle read action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 0),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text(
                    'Read',
                    style: TextStyle(
                      color: Color(0xFF5D5CBB),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                  onPressed: () {
                    // Handle edit action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.file_download_outlined, color: Colors.white, size: 20),
                  onPressed: () {
                    // Handle download action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                  onPressed: () {
                    // Handle comment action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white, size: 20),
                  onPressed: () {
                    // Handle share action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
