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
                child: SizedBox(
                  height: MediaQuery.of(context).size.height, // make it full screen
                  width: double.infinity,
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
                'https://imgs.search.brave.com/XtOdQ8wX97ghjEQQyQTwhSkWf73t_dlYhB2LSLeEW-Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jLnNh/YXZuY2RuLmNvbS9h/cnRpc3RzL0FyaWpp/dF9TaW5naF8wMDRf/MjAyNDExMTgwNjM3/MTdfNTAweDUwMC5q/cGc',
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 60,
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                'https://imgs.search.brave.com/XOUDQ-CuDlT_eZRlCduAsBrVMHKK_P1FgHOalpp6Reo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy9l/L2U0L0xhdGFfTWFu/Z2VzaGthcl8tX3N0/aWxsXzI5MDY1X2Ny/b3AuanBn',
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: 50,
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                'https://imgs.search.brave.com/8UA9BCmpxih6jP4Bh1hO9O4oVX0PdYnGA65x1G5nJG0/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9ib21i/YXlzYW1hY2hhci5j/b20vd3AtY29udGVu/dC91cGxvYWRzLzIw/MjUvMTAvS2VkYXIt/RGF2ZS00Ny0xLmpw/Zw',
              ),
            ),
          ),
          Positioned(
            left: 170,
            top: 50,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://imgs.search.brave.com/aCi7IJWqti0h3NMob415hykwrNbQiEWgyBA8amISsxk/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG4u/YnJpdGFubmljYS5j/b20vMTcvMjQ5NjE3/LTA1MC00NTc1QUI0/Qy9FZC1TaGVlcmFu/LXBlcmZvcm1zLVJv/Y2tlZmVsbGVyLVBs/YXphLVRvZGF5LVNo/b3ctTmV3LVlvcmst/MjAyMy5qcGc_dz00/MDAmaD0zMDAmYz1j/cm9w',
              ),
            ),
          ),
          Positioned(
            left: 230,
            top: 5,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://imgs.search.brave.com/7Y_9l8vSg7wSkRLOdH9jWxcSnnnDka-HBeAqh2DDVzg/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9taXIt/czMtY2RuLWNmLmJl/aGFuY2UubmV0L3By/b2plY3RzLzQwNC8w/NDYwZGQxOTUwNjky/MzEuWTNKdmNDdzVN/REFzTnpBekxEQXNP/VGcuanBn',
              ),
            ),
          ),
          Positioned(
            left: 230,
            top: 80,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://imgs.search.brave.com/7Y_9l8vSg7wSkRLOdH9jWxcSnnnDka-HBeAqh2DDVzg/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9taXIt/czMtY2RuLWNmLmJl/aGFuY2UubmV0L3By/b2plY3RzLzQwNC8w/NDYwZGQxOTUwNjky/MzEuWTNKdmNDdzVN/REFzTnpBekxEQXNP/VGcuanBn',
              ),
            ),
          ),
          Positioned(
            left: 100,
            top: 80,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://imgs.search.brave.com/HEpGAPlzUfUPlMbRGAYGu9xl-bEhLUqNxyLjbhHR3KE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJjYXZlLmNv/bS93cC93cDkwMjA2/MzAuanBn',
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
