import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:songquest/bloc/auth_bloc/auth_bloc.dart';
import 'package:songquest/helper/snackbar.dart';

class ConfirmationScreen extends StatelessWidget {
  final String email;

  const ConfirmationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthVerificationEmailSent) {
          showAppSnackBar(context, 'Verification email sent!');
        } else if (state is AuthFailure) {
          showAppSnackBar(context, state.message, isError: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.go('/login'),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // const Spacer(),
                Image.asset('assets/icons/email_sent.png', height: 350),
                const SizedBox(height: 5),
                Text(
                  'Confirm your email address',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'We sent a confirmation email to:',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 36),
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  'Check your email and click on the confirmation link to continue.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthSendVerificationEmailRequested(email: email),
                    );
                  },
                  child: Text(
                    'Resend email',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
