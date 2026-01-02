import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final List<Widget>? actions;
  final Widget? title;
  final Widget? content;
  final Color? backgroundColor;

  const CustomDialog({super.key, this.actions, this.title, this.content, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dialog = AlertDialog(
      title: title,
      content: content,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      titleTextStyle: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      actions: actions,
    );

    return dialog;
  }
}
