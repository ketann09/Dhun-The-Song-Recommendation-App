import 'package:dhun/core/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:dhun/core/widgets/app_bg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
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
                  "Log In",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                const SizedBox(height: 40),
                const Text("Email", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: "name@domain.com",
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
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
                const SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2
                            )
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text("Terms and Conditions")
                      ],
                    ),
                    TextButton(
                      onPressed: (){},
                       child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                       )
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                GradientButton(
                  text: "Login",
                  onPressed: () {
                    print("Login Button tapped!");
                  },
                ),
                const SizedBox(height: 40,),
                const Row(
                  children: [
                    Expanded(
                      child:Divider(color: Colors.white54,)),
                      Padding(padding:
                      EdgeInsetsGeometry.symmetric(horizontal: 16.0),
                       child: Text(
                        "Or",
                        style: TextStyle(color: Colors.white54),
                       ),
                       ),
                       Expanded(child: Divider(color: Colors.white54,))
                      
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
