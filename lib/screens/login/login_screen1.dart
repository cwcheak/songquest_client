// lib/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class LoginScreen1 extends StatefulWidget {
  const LoginScreen1({super.key});

  @override
  State<LoginScreen1> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen1> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'sample@email.com');
    _passwordController = TextEditingController(text: '1234567890');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                // Logo
                Image.asset(
                  'assets/logo.png',
                  height: 180,
                  // Ensure you have your logo in the assets folder
                ),
                const SizedBox(height: 40),

                // Email Field
                Text(
                  'Enter your email',
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'user@example.com',
                    // The checkmark icon indicates validation.
                    // This can be made dynamic based on email validation logic.
                    suffixIcon: Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                Text(
                  'Enter your password',
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: '****************',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Handle forgot password
                    },
                    child: const Text('forgot password?'),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Handle login logic
                  },
                  child: Text(
                    'Login',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Social Login Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or create account using social media',
                        style: textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 30),

                // Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton('assets/icons/facebook.png', () {
                      /* TODO: Facebook login */
                    }),
                    const SizedBox(width: 20),
                    _buildSocialButton('assets/icons/google.png', () {
                      /* TODO: Google login */
                    }),
                    const SizedBox(width: 20),
                    _buildSocialButton('assets/icons/apple.png', () {
                      /* TODO: Apple login */
                    }),
                  ],
                ),
                const SizedBox(height: 50),

                // Sign Up Link
                // Note: The original image text was "Already have an account? Sign In",
                // which is unusual for a login screen. Changed to a more logical "Sign Up" prompt.
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: textTheme.bodyMedium,
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Navigate to Sign Up Screen
                            },
                        ),
                      ],
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

  Widget _buildSocialButton(String assetPath, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Image.asset(
        assetPath,
        height: 24,
        width: 24,
      ),
    );
  }
}
