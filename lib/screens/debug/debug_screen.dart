import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:songquest/bloc/auth_bloc/auth_bloc.dart';
import 'package:songquest/helper/http.dart';
import 'package:songquest/helper/logger.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              context.go('/login');
            }
          },
          builder: (context, state) => Column(
            children: [
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthSignOutRequested());
                },
                child: const Text('Logout'),
              ),
              TextButton(onPressed: () => testSentry(), child: const Text("Throw Test Exception")),
              TextButton(onPressed: () => testApiCall(context), child: const Text("Test API Call")),
            ],
          ),
        ),
      ),
    );
  }

  void testSentry() async {
    try {
      Logger.instance.d("testSentry");
      throw StateError('Sentry Test Exception');
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }

  void testApiCall(BuildContext context) async {
    try {
      Logger.instance.d("testApiCall");
      final response = await HttpClient.get('http://0.0.0.0:8080/test');

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('API Success'),
            content: Text('Status: ${response.statusCode}\n\nResponse: ${response.data}'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
        );
      }
    } catch (e) {
      Logger.instance.e("testApiCall error: $e");

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('API Error'),
            content: Text('Error: $e'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
        );
      }
    }
  }
}
