import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyPlaylistScreen extends StatefulWidget {
  const MyPlaylistScreen({super.key});

  @override
  State<MyPlaylistScreen> createState() => _MyPlaylistScreenState();
}

class _MyPlaylistScreenState extends State<MyPlaylistScreen> {
  bool _isPlaylistEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Playlist'),
        /*
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // TODO: Handle more options
            },
          ),
          IconButton(
            icon: const Icon(Icons.visibility_outlined),
            onPressed: () {
              // TODO: Handle visibility
            },
          ),
        ],
        */
      ),
      body: _isPlaylistEmpty
          ? const Center(child: Text('Your playlist is empty.'))
          : ListView(
              children: [
                _buildPlaylistItem(context, 'Oldies Songs', '1 song', true),
                _buildPlaylistItem(
                  context,
                  'My Favourite Songs',
                  '0 songs',
                  false,
                ),
                _buildPlaylistItem(context, 'Hot List', '30 songs', false),
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
            // TODO: Handle add new song
          },
          child: const Text('Add New Playlist'),
        ),
      ),
    );
  }
}

Widget _buildPlaylistItem(
  BuildContext context,
  String title,
  String subtitle,
  bool isSelected,
) {
  return ListTile(
    leading: const Icon(Icons.music_note),
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showOptionsBottomSheet(context);
          },
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right),
      ],
    ),
    onTap: () {
      context.push('/playlist-items');
    },
  );
}

void _showOptionsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Rename'),
            onTap: () {
              Navigator.pop(context);
              _showRenameDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      );
    },
  );
}

void _showRenameDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Rename Playlist'),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Handle rename
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      );
    },
  );
}

void _showDeleteConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Playlist'),
        content: const Text('Are you sure you want to delete this playlist?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Handle delete
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
