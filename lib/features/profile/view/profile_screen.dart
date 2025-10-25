import 'package:dhun/core/widgets/app_bg.dart';
import 'package:dhun/core/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBg(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildAppBar(context),
                      const SizedBox(height: 24),
                      _buildProfileHeader(),
                      const SizedBox(height: 32),
                     _buildSettingsTile(icon: Icons.edit_outlined, title: 'Edit Profile'),
                     _buildSettingsTile(icon: Icons.graphic_eq, title: 'Audio Quality'),
                     _buildSettingsTile(icon: Icons.video_settings_outlined, title: 'Video Quality'),
                     _buildSettingsTile(icon: Icons.cloud_download_outlined, title: 'Downloaded'),
                     _buildSettingsTile(icon: Icons.language, title: 'Language'),
                     _buildSettingsTile(icon: Icons.storage, title: 'Storage'),
                     _buildSettingsTile(icon: Icons.settings_outlined, title: 'Setting'),
                     _buildSettingsTile(icon: Icons.feedback_outlined, title: 'Feedbacks'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const NavBar(),
        ],
      ),
    );
  }
}

Widget _buildAppBar(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      const Text(
        'Profile',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      Row(
        children: [
          IconButton(icon: const Icon(Icons.notifications_none_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
    ],
  );
}




Widget _buildProfileHeader() {
  final User? user = FirebaseAuth.instance.currentUser;

  // Default values
  String initial = '?';
  String firstName = 'User';
  String email = '';

  if (user != null) {
    // Use null-aware access
    email = user.email ?? '';

    if (user.displayName != null && user.displayName!.isNotEmpty) {
      firstName = user.displayName!.split(' ').first;
    } else if (email.isNotEmpty) {
      firstName = email.split('@').first;
    }

    if (firstName.isNotEmpty) {
      initial = firstName[0].toUpperCase();
    }
  }

  return Row(
      children: [
      CircleAvatar(
      radius: 40,
      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.8),
      backgroundImage: (user?.photoURL != null && user!.photoURL!.isNotEmpty)
          ? NetworkImage(user.photoURL!)
          : null,
      child: (user?.photoURL == null || user!.photoURL!.isEmpty)
          ? Text(
          initial,
          style: const TextStyle(
              fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
      )
          : null,
      ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firstName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ],
  );
}
Widget _buildSettingsTile({required IconData icon, required String title}) {
  return Column(
    children: [
      ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        onTap: () {},
      ),
      const Divider(color: Colors.white24, indent: 16, endIndent: 16),
    ],
  );
}