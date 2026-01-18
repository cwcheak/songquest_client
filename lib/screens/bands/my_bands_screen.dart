import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'scan_band_qr_screen.dart';

class MyBandsScreen extends StatefulWidget {
  const MyBandsScreen({super.key});

  @override
  State<MyBandsScreen> createState() => _MyBandsScreenState();
}

class _MyBandsScreenState extends State<MyBandsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showDummyData = false;
  late TextEditingController _nameController;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bands'),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        bottom: TabBar(
          controller: _tabController,
          // isScrollable: true,
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
            Icon(
              Icons.group_add_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            const Text('You are not leading any bands yet.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showCreateBandBottomSheet(context),
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
          leading: const Icon(Icons.group, size: 22),
          title: Text(
            leadBands[index],
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, letterSpacing: -0.2),
          ),
          trailing: const Icon(Icons.chevron_right, size: 22),
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
            Icon(
              Icons.group_add_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
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
          leading: const Icon(Icons.group, size: 22),
          title: Text(
            memberBands[index],
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, letterSpacing: -0.2),
          ),
          trailing: const Icon(Icons.chevron_right, size: 22),
          onTap: () {
            context.push('/band-details', extra: {'bandName': memberBands[index]});
          },
        );
      },
    );
  }

  void _showCreateBandBottomSheet(BuildContext context) {
    // Reset state for each show
    _nameController.clear();
    _showError = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 4 + 40,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Create New Band",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                maxLength: 30,
                autofocus: true,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  labelText: "Band Name (Required, max 30 characters)",
                  labelStyle: const TextStyle(color: Colors.grey),
                  errorText: _showError ? 'Please enter a valid band name' : null,
                ),
                onChanged: (value) {
                  if (_showError) {
                    setState(() {
                      _showError = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final bandName = _nameController.text.trim();
                    if (bandName.isEmpty) {
                      setState(() {
                        _showError = true;
                      });
                      return;
                    }
                    Navigator.of(context).pop();
                    context.push('/band-members', extra: {'bandName': bandName});
                  },
                  child: const Text("Create"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
