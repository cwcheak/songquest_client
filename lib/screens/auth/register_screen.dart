import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:songquest/bloc/auth_bloc/auth_bloc.dart';
import 'package:songquest/helper/snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final FormGroup form;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    form = FormGroup(
      {
        'fullName': FormControl<String>(
          value: '',
          validators: [
            Validators.required,
            Validators.minLength(2),
            Validators.pattern(r'^[a-zA-Z\s]+$'),
          ],
        ),
        'email': FormControl<String>(
          value: '',
          validators: [Validators.required, Validators.email],
        ),
        'phone': FormControl<String>(
          value: '',
          validators: [Validators.required, Validators.pattern(r'^(01|\+601)[0-9]{8,9}$')],
        ),
        'password': FormControl<String>(
          value: '',
          validators: [Validators.required, Validators.minLength(8)],
        ),
        'confirmPassword': FormControl<String>(value: '', validators: [Validators.required]),
      },
      validators: [Validators.mustMatch('password', 'confirmPassword')],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ReactiveForm(
              formGroup: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  // Role Selection
                  Text(
                    'I am a...',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRole = 'Band member';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _selectedRole == 'Band member'
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedRole == 'Band member'
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                                width: _selectedRole == 'Band member' ? 2 : 1,
                              ),
                              boxShadow: _selectedRole == 'Band member'
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Band Member',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedRole == 'Band member'
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRole = 'Cafe/Bar/Event manager';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _selectedRole == 'Cafe/Bar/Event manager'
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedRole == 'Cafe/Bar/Event manager'
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                                width: _selectedRole == 'Cafe/Bar/Event manager' ? 2 : 1,
                              ),
                              boxShadow: _selectedRole == 'Cafe/Bar/Event manager'
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Cafe/Bar/Event Manager',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedRole == 'Cafe/Bar/Event manager'
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_selectedRole == null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Please select a role',
                        style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 14),
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Full Name Field
                  ReactiveTextField<String>(
                    formControlName: 'fullName',
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    validationMessages: {
                      ValidationMessage.required: (_) => 'Full name is required',
                      ValidationMessage.minLength: (_) => 'Full name must be at least 2 characters',
                      ValidationMessage.pattern: (_) =>
                          'Full name can only contain letters and spaces',
                    },
                  ),
                  const SizedBox(height: 16),

                  // E-mail Field
                  ReactiveTextField<String>(
                    formControlName: 'email',
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validationMessages: {
                      ValidationMessage.required: (_) => 'Email is required',
                      ValidationMessage.email: (_) => 'Please enter a valid email address',
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  ReactiveTextField<String>(
                    formControlName: 'phone',
                    decoration: const InputDecoration(labelText: 'Phone', errorMaxLines: 2),
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
                    validationMessages: {
                      ValidationMessage.required: (_) => 'Phone number is required',
                      ValidationMessage.pattern: (_) =>
                          'Please enter a valid Malaysian mobile number (e.g., 0123456789 or +60123456789)',
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  ReactiveTextField<String>(
                    formControlName: 'password',
                    obscureText: !_isPasswordVisible,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorMaxLines: 2,
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (_) => 'Password is required',
                      ValidationMessage.minLength: (_) => 'Password must be at least 8 characters',
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  ReactiveTextField<String>(
                    formControlName: 'confirmPassword',
                    obscureText: !_isConfirmPasswordVisible,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      errorMaxLines: 2,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (_) => 'Please confirm your password',
                      ValidationMessage.mustMatch: (_) => 'Passwords do not match',
                    },
                  ),
                  const SizedBox(height: 40),

                  // Register Button
                  ReactiveFormConsumer(
                    builder: (context, form, child) {
                      return BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthFailure) {
                            showAppSnackBar(context, state.message, isError: true);
                          } else if (state is AuthUnauthenticated) {
                            context.go(
                              '/confirmation',
                              extra: {'email': form.value['email'] as String},
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                            ),
                            onPressed:
                                (form.valid && _selectedRole != null && state is! AuthLoading)
                                ? () {
                                    final formValue = form.value;
                                    context.read<AuthBloc>().add(
                                      AuthSignUpWithEmailRequested(
                                        email: formValue['email'] as String,
                                        password: formValue['password'] as String,
                                      ),
                                    );
                                  }
                                : null,
                            child: state is AuthLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Register',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // "Have account? Sign In" Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // Navigate back to the login screen
                      context.pop();
                    },
                    child: Text(
                      'Have account? Sign In',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
