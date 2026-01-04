import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// A utility class to handle back button confirmation across the app
class BackButtonHandler {
  /// Shows a confirmation dialog when the user tries to exit the app
  /// Returns true if the app should exit, false if navigation should be prevented
  static Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Don't exit
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Exit app
                  },
                  child: const Text('Exit'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// A widget that wraps any screen with back button confirmation
  /// Use this as the root widget in your screens
  /// This approach uses PopScope which is the recommended way for handling back navigation
  static Widget withBackConfirmation({required Widget child, required BuildContext context}) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldExit = await showExitConfirmationDialog(context);
        if (shouldExit == true) {
          // Exit the app on Android and iOS
          if (Platform.isAndroid) {
            // For Android, we can use SystemNavigator.pop()
            // This will close the app
            // Note: This might not work in all cases, so we also try other methods
            try {
              // Try to close the app by popping all routes
              Navigator.of(context).popUntil((route) => route.isFirst);
              // If that doesn't work, try SystemNavigator
              // SystemNavigator.pop();
            } catch (e) {
              // If all else fails, we can't actually force close the app
              // But we can show a message or handle it gracefully
            }
          } else if (Platform.isIOS) {
            // For iOS, we typically don't force close apps
            // Instead, we can show a message or handle it gracefully
            // iOS users are expected to use the home button/gesture
          }
        }
      },
      child: child,
    );
  }
}
