import 'package:dhun/core/widgets/solid_button.dart';
import 'package:flutter/material.dart';
import 'package:dhun/core/widgets/app_bg.dart'; 

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBg(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    "Reset Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Colors.white 
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "To reset the password of the existing account, enter the details",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    "Account Verification",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Enter Email",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "name@domain.com",
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16,horizontal: 20),
                    ),
                    style: const TextStyle(fontSize: 16),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Note - After Verification of your email, as password resent link will be shared on the same.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SolidButton(
                    text: 
                    " Verify Emial", onPressed: (){})
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}