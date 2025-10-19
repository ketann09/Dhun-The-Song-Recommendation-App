import 'package:dhun/features/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhun/core/widgets/app_bg.dart';
import 'package:dhun/features/onboarding/bloc/onboarding_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => OnboardingBloc(),
    child: Builder(
      builder: (context) { 
        return BlocListener<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state is NavigatingToHome) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
          child: Scaffold(
            body: AppBg( 
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/images/headphones.png', height: 250),
                      _buildArtistAvatars(),
                      _buildTextContent(),
                      _buildLetsGoButton(context),   
                      ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

  Widget _buildArtistAvatars() {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Positioned(
            top: 10,
            left: 100,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://in.pinterest.com/pin/824158800534587359/',
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 60,
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                'https://i.scdn.co/image/ab6761610000e5eb0261696c5e23615c130388c3',
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: 50,
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                'https://i.scdn.co/image/ab6761610000e5ebcb6b89b6f16b2d5d8c1c5102',
              ),
            ),
          ),
          Positioned(
            left: 170,
            top: 50,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://i.scdn.co/image/ab6761610000e5ebcb6b89b6f16b2d5d8c1c5102',
              ),
            ),
          ),
          Positioned(
            left: 230,
            top: 5,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://i.scdn.co/image/ab6761610000e5eb0261696c5e23615c130388c3',
              ),
            ),
          ),
          Positioned(
            left: 230,
            top: 80,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://i.scdn.co/image/ab6761610000e5eb0261696c5e23615c130388c3',
              ),
            ),
          ),
          Positioned(
            left: 100,
            top: 80,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://i.scdn.co/image/ab6761610000e5ebcb6b89b6f16b2d5d8c1c5102',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Text(
            'Discover music tailored for endless inspirations',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Discover music tailored to your soul, mood, and every unique moment',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLetsGoButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          context.read<OnboardingBloc>().add(LetsGoButtonPressed());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Colors.pinkAccent, Colors.purple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: const Center(
            child: Text(
              "Let's Go",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
