import 'package:flutter/material.dart';
import 'package:dhun/features/onboarding/view/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is the root widget of your app.
    return MaterialApp(
      title: 'Song Rec App',
      // This removes the little "Debug" banner from the corner.
      debugShowCheckedModeBanner: false,
      // We can define a theme later, for now dark theme is a good start.
      theme: ThemeData.dark(),
      // This is the most important line!
      // It tells the app to use our OnboardingScreen as the first screen.
      home: const OnboardingScreen(),
    );
  }
}