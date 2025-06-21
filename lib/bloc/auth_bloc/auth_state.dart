part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final firebase_auth.User firebaseUser;
  const AuthAuthenticated(this.firebaseUser);
}

class AuthUnauthenticated extends AuthState {
  final String? message;
  const AuthUnauthenticated({this.message});
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
