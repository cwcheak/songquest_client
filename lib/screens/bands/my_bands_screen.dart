import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'scan_band_qr_screen.dart';

class MyBandsScreen extends StatefulWidget {
  const MyBandsScreen({super.key});

  @override
  State<MyBandsScreen> createState() => _MyBandsScreenState();
}

class _MyBandsScreenState extends State<MyBandsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showDummyData = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bands'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'As Lead'),
            Tab(text: 'As Member'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAsLeadTab(), _buildAsMemberTab()],
      ),
    );
  }

  Widget _buildAsLeadTab() {
    // TODO: Replace with actual data
    final leadBands = _showDummyData
        ? ['The Rock Stars', 'Jazz Masters', 'Pop Sensations']
        : <String>[];

    if (leadBands.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are not leading any bands yet.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showCreateBandDialog(context),
              child: const Text('Create New Band'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: leadBands.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.group),
          title: Text(leadBands[index]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to band details
          },
        );
      },
    );
  }

  Widget _buildAsMemberTab() {
    // TODO: Replace with actual data
    final memberBands = _showDummyData
        ? ['The Melody Makers', 'Harmony Crew', 'Rhythm Section']
        : <String>[];

    if (memberBands.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are not a member of any bands yet.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push('/scan-band-qr');
              },
              child: Text('Scan Band QR'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: memberBands.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.group),
          title: Text(memberBands[index]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.push(
              '/band-details',
              extra: {'bandName': memberBands[index]},
            );
          },
        );
      },
    );
  }

  void _showCreateBandDialog(BuildContext context) {
    String bandName = '';
    bool showError = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create New Band'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Band Name',
                      hintText: 'Enter band name',
                      errorText: showError
                          ? 'Please enter a valid band name'
                          : null,
                    ),
                    onChanged: (value) {
                      bandName = value;
                      if (showError) {
                        setState(() {
                          showError = false;
                        });
                      }
                    },
                  ),
                ],
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
                    if (bandName.trim().isEmpty) {
                      setState(() {
                        showError = true;
                      });
                      return;
                    }
                    Navigator.pop(context);
                    context.push(
                      '/add-members',
                      extra: {'bandName': bandName.trim()},
                    );
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
