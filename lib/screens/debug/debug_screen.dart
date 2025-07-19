import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:songquest/bloc/auth_bloc/auth_bloc.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debug')),
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            child: const Text('Logout'),
          ),
        ),
      ),
    );
  }
}
