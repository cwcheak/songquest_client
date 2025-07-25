import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:songquest/bloc/auth_bloc/auth_bloc.dart';
import 'package:songquest/helper/snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showAppSnackBar(context, state.message, isError: true);
        } else if (state is AuthPasswordResetEmailSent) {
          showAppSnackBar(
            context,
            'Password reset email sent! Please check your inbox.',
          );
          context.pop(); // Return to previous screen
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: Colors.black87,
                onPressed: () => context.pop(),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Forgot Password',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter the email associated with your account',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 30),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_emailController.text.isNotEmpty) {
                                context.read<AuthBloc>().add(
                                  AuthSendPasswordResetEmailRequested(
                                    email: _emailController.text,
                                  ),
                                );
                              } else {
                                showAppSnackBar(
                                  context,
                                  'Please enter your email',
                                  isError: true,
                                );
                              }
                            },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'Send Code',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
