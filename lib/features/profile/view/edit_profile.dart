import 'package:dhun/core/widgets/app_bg.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBg(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildAppBar(context),
                  _buildProfileHeader(),
                  _buildCustomTextField(label: 'Name', hint: 'Enter Your Name'),
                  _buildCustomTextField(label: 'Gender', hint: 'Please select gender'),
                  _buildCustomTextField(label: 'Email', hint: 'name@domain.com'),
                  _buildCustomTextField(label: 'Mobile'),
                  _buildCustomTextField(label: 'Date of Birth', hint: 'Please select date of birth'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildAppBar(BuildContext context) {
  return Row(
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      const Expanded(
        child: Center(
          child: Text(
            'Edit Your Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(width: 40), 
    ],
  );
}

Widget _buildProfileHeader() {
  return Column(
    children: [
      const SizedBox(height: 32),
      const CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
      ),
      const SizedBox(height: 8),
      const Text(
        'Your Name',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      _buildGradientBorderButton(
        text: 'Change your Photo',
        onPressed: () {},
      ),
      const SizedBox(height: 48),
    ],
  );
}

Widget _buildCustomTextField({
  required String label,
  String hint = '',
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 24.0),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.purpleAccent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
        ),
      ),
    ),
  );
}

Widget _buildGradientBorderButton({required String text, required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Colors.purpleAccent, Colors.blueAccent],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(128), 
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}