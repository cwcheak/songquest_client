import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaylistItemsScreen extends StatefulWidget {
  const PlaylistItemsScreen({super.key});

  @override
  State<PlaylistItemsScreen> createState() => _PlaylistItemsScreenState();
}

class _PlaylistItemsScreenState extends State<PlaylistItemsScreen> {
  bool _isSongListEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oldies Songs (3)')),
      body: _isSongListEmpty
          ? const Center(child: Text('There are no songs in this playlist.'))
          : ListView(
              children: [
                _buildSongItem(
                  context,
                  'assets/icons/google.png',
                  'Kiss Goodbye',
                  'Jacky Cheung',
                ),
                _buildSongItem(
                  context,
                  'assets/icons/google.png',
                  'Hostage',
                  'A-Mei',
                ),
                _buildSongItem(
                  context,
                  'assets/icons/google.png',
                  'My Dearest',
                  'A-Mei',
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            context.push('/add-song');
          },
          child: const Text('Add Song'),
        ),
      ),
    );
  }
}

Widget _buildSongItem(
  BuildContext context,
  String imagePath,
  String title,
  String artist,
) {
  return ListTile(
    leading: CircleAvatar(backgroundImage: AssetImage(imagePath)),
    title: Text(title),
    subtitle: Text(artist),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            // TODO: Handle delete song
          },
        ),
      ],
    ),
  );
}
