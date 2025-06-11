import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class DrawerContent extends  ConsumerStatefulWidget  {
  final VoidCallback onLogout;
  final void Function(String route) onNavigate;
  
  const DrawerContent({
    super.key,
    required this.onLogout,
    required this.onNavigate,
   
  });

    @override
  ConsumerState<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends ConsumerState<DrawerContent> {
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
  Widget build(BuildContext context,) {
    final user = ref.watch(currentUserProvider);
    final name = user?.name ?? "Guest User";
    final email = user?.email ?? "no email";

    final items = <_DrawerItem>[
      _DrawerItem(label: "Home", route: "/home", icon: Icons.home_outlined),
      _DrawerItem(
          label: "Profile", route: "/profile", icon: Icons.person_outline),
      _DrawerItem(
          label: "Bookmark",
          route: "/favourites",
          icon: Icons.favorite_border_outlined),
      _DrawerItem(
          label: "Create Category",
          route: "/createCategory",
          icon: Icons.grid_view_outlined),
      _DrawerItem(
          label: "View Category",
          route: "/viewcategory",
          icon: Icons.view_list_outlined),
    ];

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
                Stack(
  children: [
    CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      backgroundImage: _profileImage != null
          ? FileImage(_profileImage!)
          : (_webImage != null
              ? MemoryImage(_webImage!)
              : AssetImage('assets/images/profile_img.png')) as ImageProvider,
    ),
    Positioned(
      bottom: 0,
      right: 0,
      child: InkWell(
        onTap: _pickImage,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          padding: const EdgeInsets.all(6),
          child: const Icon(
            Icons.camera_alt,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ],
),

                const SizedBox(height: 12),
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white)),
                Text(email,
                    style: const TextStyle(fontSize: 14, color: Colors.white)),
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
                  for (final item in items)
                    InkWell(
                      onTap: () => widget.onNavigate(item.route),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Icon(item.icon,
                                size: 23, color: const Color(0xFF36454F)),
                            const SizedBox(width: 12),
                            Text(item.label,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF36454F))),
                          ],
                        ),
                      ),
                    ),
                  const Spacer(),
                  const Divider(color: Colors.grey, indent: 0, endIndent: 16),
                  InkWell(
                    key: const Key('drawer_logout'),
                    onTap: () {
                      widget.onLogout();
                      ref.read(userRoleProvider.notifier).state = null;
                      ref.read(currentUserProvider.notifier).state = null;
                     // optional callback to parent
                      GoRouter.of(context).go('/login');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: const [
                          Icon(Icons.logout_outlined,
                              size: 23, color: Color(0xFF36454F)),
                          SizedBox(width: 12),
                          Text("Logout",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF36454F))),
                        ],
                      ),
                    ),
                  ),
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
  _DrawerItem({required this.label, required this.route, required this.icon});
}
