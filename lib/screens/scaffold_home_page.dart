import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Stateful nested navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldHomePage extends StatelessWidget {
  const ScaffoldHomePage({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldHomePage'));

  final StatefulNavigationShell navigationShell;

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    // Map shell branches to tab indices:
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/settings')) return 2;
    return 0; // Default to first tab
  }

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      if (index == 1) {
        // Navigate to add_invoice route for the second destination
        GoRouter.of(context).push('/add-invoice');
      } else {
        // For icons after + (index >= 2), adjust index to index - 1
        int adjustedIndex = index > 1 ? index - 1 : index;
        navigationShell.goBranch(
          adjustedIndex,
          initialLocation: adjustedIndex == navigationShell.currentIndex,
        );
      }
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        destinations: const [
          NavigationDestination(label: 'Home', icon: Icon(Icons.home)),
          NavigationDestination(label: '+', icon: Icon(Icons.plus_one)),
          NavigationDestination(label: 'More', icon: Icon(Icons.settings)),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
