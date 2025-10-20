import 'package:dhun/core/widgets/app_bg.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: AppBg(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildAppBar(context),
                _buildAlbumArt(),
                _buildSongInfo(),
                const SizedBox(height: 16),
                _buildProgressBar(context),
                _buildPlayerControls(),
                _buildSocialActions(),
                
                const Column(
                  children: [
                    Icon(Icons.keyboard_arrow_up),
                    Text('More'),
                  ],
                ),
                const SizedBox(height: 16), 
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
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      const Text(
        'Now Playing',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      IconButton(
        icon: const Icon(Icons.fullscreen, size: 28),
        onPressed: () {},
      ),
    ],
  );
}

Widget _buildAlbumArt() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 32.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset('assets/images/saiyaara.png',
        height: 300,
        width: 300,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _buildSongInfo() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saiyaara',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Tanishka Bagchi',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
      IconButton(
        icon: const Icon(Icons.favorite_border, size: 32),
        onPressed: () {},
      ),
    ],
  );
}

Widget _buildProgressBar(BuildContext context) {
  // We'll use dummy values for now.
  // This will be managed by a state variable later.
  double _currentSliderValue = 20;

  return Column(
    children: [
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 2.0,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
          activeTrackColor: Colors.purpleAccent,
          inactiveTrackColor: Colors.grey.shade700,
          thumbColor: Colors.white,
        ),
        child: Slider(
          value: _currentSliderValue,
          min: 0,
          max: 100,
          onChanged: (value) {
            // setState will be used here later
          },
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1:24'),
            Text('3:58'),
          ],
        ),
      ),
    ],
  );
}

Widget _buildPlayerControls() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 24.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous, size: 40),
          onPressed: () {},
        ),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.purpleAccent,
          ),
          child: IconButton(
            icon: const Icon(Icons.play_arrow, size: 60, color: Colors.white),
            onPressed: () {},
          ),
        ),
        IconButton(
          icon: const Icon(Icons.skip_next, size: 40),
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget _buildSocialActions() {
  Widget buildSocialButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      buildSocialButton(Icons.favorite, '1.0M'),
      buildSocialButton(Icons.comment, '7.5K'),
      buildSocialButton(Icons.share, '5K'),
    ],
  );
}