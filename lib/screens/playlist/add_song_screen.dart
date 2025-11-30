import 'package:flutter/material.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  bool _isSongListEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Song')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Artist Name',
                    hintText: 'Enter artist name',
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Song Name',
                    hintText: 'Enter song name',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isSongListEmpty
                ? const Center(child: Text('No songs found.'))
                : ListView(
                    children: [
                      _buildRecommendedSongItem(
                        context,
                        'assets/icons/google.png',
                        'Later',
                        'Rene Liu',
                      ),
                      _buildRecommendedSongItem(
                        context,
                        'assets/icons/google.png',
                        'Chengdu',
                        'Zhao Lei',
                      ),
                      _buildRecommendedSongItem(
                        context,
                        'assets/icons/google.png',
                        'Ten Years',
                        'Eason Chan',
                      ),
                      _buildRecommendedSongItem(
                        context,
                        'assets/icons/google.png',
                        'Confession Balloon',
                        'Jay Chou',
                      ),
                      _buildRecommendedSongItem(
                        context,
                        'assets/icons/google.png',
                        'Sunny Day',
                        'Jay Chou',
                      ),
                      _buildRecommendedSongItem(
                        context,
                        'assets/icons/google.png',
                        'Qilixiang',
                        'Jay Chou',
                      ),
                    ],
                  ),
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
          onPressed: () {},
          child: const Text('Song not found, create new song'),
        ),
      ),
    );
  }
}

Widget _buildRecommendedSongItem(
  BuildContext context,
  String imagePath,
  String title,
  String artist,
) {
  return ListTile(
    leading: CircleAvatar(backgroundImage: AssetImage(imagePath)),
    title: Text(title),
    subtitle: Text(artist),
    trailing: IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: () {
        // TODO: Handle delete song
      },
    ),
  );
}
