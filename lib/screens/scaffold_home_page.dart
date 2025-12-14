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
    if (location.startsWith('/order')) return 1;
    if (location.startsWith('/menu')) return 2;
    if (location.startsWith('/rewards')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      navigationShell.goBranch(index);
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        destinations: const [
          NavigationDestination(label: 'Home', icon: Icon(Icons.home_outlined)),
          NavigationDestination(label: 'Order', icon: Icon(Icons.receipt_long_outlined)),
          NavigationDestination(label: 'Menu', icon: Icon(Icons.menu_book_outlined)),
          NavigationDestination(label: 'Rewards', icon: Icon(Icons.card_giftcard_outlined)),
          NavigationDestination(label: 'Account', icon: Icon(Icons.person_outline)),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
