part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final firebase_auth.User? firebaseUser;
  AuthUserChanged(this.firebaseUser);
}

class AuthSignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  AuthSignInWithEmailRequested({required this.email, required this.password});
}

class AuthSignUpWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String role;
  AuthSignUpWithEmailRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.role,
  });
}

class AuthSignInWithGoogleRequested extends AuthEvent {}

class AuthSignInWithFacebookRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthSendPasswordResetEmailRequested extends AuthEvent {
  final String email;
  AuthSendPasswordResetEmailRequested({required this.email});
}

class AuthSendVerificationEmailRequested extends AuthEvent {
  final String email;
  AuthSendVerificationEmailRequested({required this.email});
}
