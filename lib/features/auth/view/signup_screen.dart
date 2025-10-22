import 'package:dhun/core/widgets/gradient_button.dart';
import 'package:dhun/features/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dhun/core/widgets/app_bg.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
final TextEditingController nameController = TextEditingController();

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBg(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),

                const Text(
                  "Sign Up",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                const SizedBox(height: 20),
                const Text("Email", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "name@domain.com",
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Text("Password", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  obscureText: _isPasswordVisible,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter your Password",
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Text("Confirm Password", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  obscureText: _isConfirmPasswordVisible,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: "Comfirm Password",
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                GradientButton(
                  text: "Sign Up",
                  onPressed: () async {
                    final authService = AuthService();

                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final confirmPassword = confirmPasswordController.text.trim();

                    if (password != confirmPassword) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Passwords do not match"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    final error = await authService.signup(
                      email,
                      password,
                      nameController.text.trim(),
                    );
                    if (error != null) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Signup Failed"),
                          content: Text(error),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white54)),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0),
                      child: Text(
                        "Or",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white54)),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Image(
                        width: 24,
                        height: 24,
                        image: AssetImage("assets/images/google.png"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Image(
                        width: 24,
                        height: 24,
                        image: AssetImage("assets/images/facebook.png"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Signin",
                        style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
