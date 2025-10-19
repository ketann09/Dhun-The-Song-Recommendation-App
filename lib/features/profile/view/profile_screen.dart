import 'package:dhun/core/widgets/app_bg.dart';
import 'package:dhun/core/widgets/navbar.dart';
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
                      const SizedBox(height: 24)
                      // 1. Custom AppBar will go here
                      // 2. Profile Header will go here
                      // 3. Settings List will go here
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