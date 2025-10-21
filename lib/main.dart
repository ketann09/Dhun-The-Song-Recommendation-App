import 'package:dhun/features/auth/view/login_screen.dart';
import 'package:dhun/features/auth/view/signup_screen.dart';
import 'package:dhun/features/home/view/home_screen.dart';
import 'package:dhun/features/player/view/player_screen.dart';
import 'package:dhun/features/search/view/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:dhun/features/onboarding/view/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song Rec App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const OnboardingScreen(),
    );
  }
}