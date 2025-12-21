import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddMembersScreen extends StatefulWidget {
  final String bandName;

  const AddMembersScreen({super.key, required this.bandName});

  @override
  State<AddMembersScreen> createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _selectedMembers = [];

  // TODO: Replace with actual member data
  final List<Map<String, dynamic>> _allMembers = [
    {'name': 'John Doe', 'email': 'john@example.com', 'phone': '0123456789'},
    {'name': 'Jane Smith', 'email': 'jane@example.com', 'phone': '0987654321'},
    {'name': 'Bob Wilson', 'email': 'bob@example.com', 'phone': '0112233445'},
  ];

  List<Map<String, dynamic>> _filteredMembers = [];

  @override
  void initState() {
    super.initState();
    _filteredMembers = _allMembers;
    _searchController.addListener(_filterMembers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        return member['name'].toLowerCase().contains(query) ||
            member['email'].toLowerCase().contains(query) ||
            member['phone'].contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Members to ${widget.bandName}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name, email or phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredMembers.isEmpty
                ? const Center(child: Text('No members found'))
                : ListView.builder(
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                      final isSelected = _selectedMembers.contains(member);

                      return CheckboxListTile(
                        title: Text(member['name']),
                        subtitle: Text(member['email']),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedMembers.add(member);
                            } else {
                              _selectedMembers.remove(member);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedMembers.isEmpty
              ? null
              : () {
                  // TODO: Handle adding selected members
                  Navigator.pop(context);
                },
          child: Text('Add Selected Members (${_selectedMembers.length})'),
        ),
      ),
    );
  }
}
