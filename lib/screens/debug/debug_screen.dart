import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:songquest/bloc/auth_bloc/auth_bloc.dart';
import 'package:songquest/helper/logger.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debug')),
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
              TextButton(
                onPressed: () => testSentry(),
                child: const Text("Throw Test Exception"),
              ),
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
}
