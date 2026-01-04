import 'dart:async';
import 'package:flutter/material.dart';

class ElapsedTimeWidget extends StatefulWidget {
  final DateTime startTime;

  const ElapsedTimeWidget({Key? key, required this.startTime}) : super(key: key);

  @override
  _ElapsedTimeWidgetState createState() => _ElapsedTimeWidgetState();
}

class _ElapsedTimeWidgetState extends State<ElapsedTimeWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Update the widget every second
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w300,
      letterSpacing: -0.2,
      color: Colors.white,
    );

    final Duration elapsed = DateTime.now().difference(widget.startTime);
    final String timeText = _formatDuration(elapsed);

    return Text(timeText, style: textStyle);
  }

  String _formatDuration(Duration duration) {
    final int totalSeconds = duration.inSeconds;
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else {
      return '${minutes}m ${seconds}s';
    }
  }
}
