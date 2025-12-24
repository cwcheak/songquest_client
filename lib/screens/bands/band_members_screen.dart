import 'package:flutter/material.dart';
import 'search_member_screen.dart';

class BandMembersScreen extends StatelessWidget {
  final String bandName;

  const BandMembersScreen({super.key, required this.bandName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bandName),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(child: _buildMemberList(context)),
    );
  }
}

void _showMemberOptionsSheet(BuildContext context, String memberName) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(memberName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Remove member from band'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                // TODO: Implement remove member functionality
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildMemberList(BuildContext context) {
  final bandMembers = [
    ['张惠妹', '歌手'],
    ['张靓颖', '鼓手'],
    ['塔斯肯', '吉他手'],
    ['Charlie Puth', '乐手'],
  ];

  if (bandMembers.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const Text('No member in your bands yet.')],
      ),
    );
  }

  return ListView.builder(
    itemCount: bandMembers.length + 1,
    itemBuilder: (context, index) {
      if (index == 0) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: _buildSearchBar(context),
        );
      }
      final memberIndex = index - 1;
      return ListTile(
        leading: const Icon(Icons.music_note),
        title: Text(bandMembers[memberIndex][0]),
        subtitle: Text(bandMembers[memberIndex][1], style: const TextStyle(color: Colors.grey)),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showMemberOptionsSheet(context, bandMembers[memberIndex][0]);
          },
        ),
        onTap: () {
          // TODO: Handle song tap (e.g., play or navigate)
        },
      );
    },
  );
}

Widget _buildSearchBar(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchMemberScreen()));
    },
    child: TextField(
      enabled: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(255, 239, 240, 241),
        constraints: BoxConstraints(maxHeight: 35),
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        hintText: 'Search and add members',
        hintStyle: const TextStyle(fontSize: 12),
        contentPadding: EdgeInsets.symmetric(vertical: 13.5, horizontal: 16),
      ),
    ),
  );
}
