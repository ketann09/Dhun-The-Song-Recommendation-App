import 'package:flutter/material.dart';

class MoreOptionsSheet extends StatelessWidget {
  const MoreOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // A helper for a single menu item row
    Widget buildMenuItem(IconData icon, String title) {
      return ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        onTap: () {},
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/images/saiyaara.png', width: 50, height: 50),
            ),
            title: const Text('Saiyaara', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Tanishka Bagchi'),
            trailing: const Text('3:58'),
          ),
          const Divider(color: Colors.white24),
          buildMenuItem(Icons.shuffle, 'Shuffle'),
          buildMenuItem(Icons.repeat, 'Repeat'),
          buildMenuItem(Icons.repeat_one, 'Repeat One'),
          buildMenuItem(Icons.favorite_border, 'Favorite'),
          buildMenuItem(Icons.playlist_add, 'Add Your Playlist'),
          buildMenuItem(Icons.download_outlined, 'Download'),
          buildMenuItem(Icons.share_outlined, 'Share'),
        ],
      ),
    );
  }
}