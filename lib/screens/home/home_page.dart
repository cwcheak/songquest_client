import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

import 'package:songquest/screens/components/custom_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return CustomDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Don't exit
                  },
                ),
                TextButton(
                  child: const Text('Exit'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Exit app
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await _showExitConfirmationDialog(context);
        if (shouldExit) {
          // Close the app
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          }
          // For iOS and other platforms, we can't force close the app
          // but the confirmation dialog serves as a safety measure
          // iOS users are expected to use the home button/gesture
        }
      },
      child: const Scaffold(
        body: Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
      ),
    );
  }
}
