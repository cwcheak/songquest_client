import 'package:flutter/material.dart';

class SongOrderItem extends StatelessWidget {
  const SongOrderItem({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark ? Colors.black87 : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 1,
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(padding: const EdgeInsets.all(16.0), child: _buildContent(context)),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final TextStyle? songTextStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2);
    final TextStyle? textTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(letterSpacing: -0.2);
    // final TextStyle? hintTextStyle = Theme.of(
    //   context,
    // ).textTheme.bodySmall?.copyWith(fontSize: 8, letterSpacing: -0.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text('David Cheong', style: textTextStyle)),
            Text('#128 (Dec 25, 10:20 PM)', style: textTextStyle),
          ],
        ),
        const SizedBox(height: 8.0),
        // Row(
        //   children: <Widget>[
        //     Expanded(child: SizedBox.shrink()),
        //     Text('2025-12-25 10:20PM', style: textTextStyle),
        //   ],
        // ),
        // Text('2025-12-25 10:20PM', style: hintTextStyle),
        Divider(),
        const SizedBox(height: 8.0),
        Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: songTextStyle,
                  children: <TextSpan>[
                    const TextSpan(text: 'Feeling Good'),
                    TextSpan(text: '  ~ Michael Buble', style: textTextStyle),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('\$20', style: textTextStyle),
          ],
        ),
        RichText(
          text: TextSpan(
            style: songTextStyle,
            children: <TextSpan>[
              const TextSpan(text: 'Perfect'),
              TextSpan(text: '  ~ Ed Sheeran', style: textTextStyle),
            ],
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8.0),
        Divider(),
        Row(
          children: [
            const Expanded(child: SizedBox.shrink()),
            TextButton(onPressed: () {}, child: const Text('Accept')),
            TextButton(onPressed: () {}, child: const Text('Reject')),
          ],
        ),
      ],
    );
  }
}
