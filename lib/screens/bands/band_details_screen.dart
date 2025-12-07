import 'package:flutter/material.dart';

class BandDetailsScreen extends StatelessWidget {
  final String bandName;

  const BandDetailsScreen({super.key, required this.bandName});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual band data
    final members = [
      {'name': 'John Doe', 'role': 'Lead'},
      {'name': 'Jane Smith', 'role': 'Member'},
      {'name': 'Bob Wilson', 'role': 'Member'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Band Details"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bandName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Members', style: Theme.of(context).textTheme.titleMedium),
                Text('${members.length} members'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(member['name']!),
                  subtitle: Text(
                    member['role']!,
                    style: TextStyle(
                      color: member['role'] == 'Lead'
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      fontWeight: member['role'] == 'Lead'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: member['role'] == 'Lead'
                      ? Chip(
                          label: Text('LEAD'),
                          backgroundColor: Theme.of(context).primaryColor,
                          labelStyle: const TextStyle(color: Colors.white),
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _showQuitConfirmationDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Text('Request to Quit Band'),
        ),
      ),
    );
  }

  void _showQuitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quit Band'),
          content: const Text(
            'Are you sure you want to request to quit this band?',
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
                // TODO: Handle quit request
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quit request submitted')),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
