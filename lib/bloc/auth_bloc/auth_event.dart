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
  AuthSignUpWithEmailRequested({required this.email, required this.password});
}

class AuthSignInWithGoogleRequested extends AuthEvent {}

class AuthSignInWithFacebookRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthSendPasswordResetEmailRequested extends AuthEvent {
  final String email;
  AuthSendPasswordResetEmailRequested({required this.email});
}
