import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Stateful nested navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldHomePage extends StatelessWidget {
  const ScaffoldHomePage({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey('ScaffoldHomePage'));

  final StatefulNavigationShell navigationShell;

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    // Map shell branches to tab indices:
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/my-bands')) return 1;
    if (location.startsWith('/menu')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      navigationShell.goBranch(index);
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: onDestinationSelected,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'My Bands',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_outlined),
            activeIcon: Icon(Icons.music_note),
            label: 'Stage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
