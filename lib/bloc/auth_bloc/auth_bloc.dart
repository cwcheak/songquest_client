import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:songquest/helper/logger.dart';
import 'package:songquest/repo/authentication_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<firebase_auth.User?> _userSubscription;

  AuthBloc({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(const AuthInitial()) {
    // Listen to authentication state changes
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );

    // Event handlers
    on<AuthUserChanged>(_onUserChanged);
    on<AuthSignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<AuthSignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    // on<AuthSignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    // on<AuthSignInWithFacebookRequested>(_onSignInWithFacebookRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthSendPasswordResetEmailRequested>(_onSendPasswordResetEmailRequested);
    on<AuthSendVerificationEmailRequested>(_onSendVerificationEmailRequested);
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    // Logger.instance.d("_onUserChanged: event.firebaseUser: ${event.firebaseUser}");
    if (event.firebaseUser != null) {
      emit(AuthAuthenticated(event.firebaseUser!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignInWithEmailRequested(
    AuthSignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Logger.instance.d("_onSignInWithEmailRequested: event: ${event.email}");
    // Logger.instance.d("_onSignInWithEmailRequested: event: ${event.password}");

    emit(const AuthLoading());
    try {
      Logger.instance.d("Start _onSignInWithEmailRequested....");
      await _authenticationRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      Logger.instance.d("Completed _onSignInWithEmailRequested....");
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Email sign in failed'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignUpWithEmailRequested(
    AuthSignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authenticationRepository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Email sign up failed'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Future<void> _onSignInWithGoogleRequested(
  //   AuthSignInWithGoogleRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(const AuthLoading());
  //   try {
  //     await _authenticationRepository.signInWithGoogle();
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     emit(AuthFailure(e.message ?? 'Google sign in failed'));
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }

  // Future<void> _onSignInWithFacebookRequested(
  //   AuthSignInWithFacebookRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(const AuthLoading());
  //   try {
  //     await _authenticationRepository.signInWithFacebook();
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     emit(AuthFailure(e.message ?? 'Facebook sign in failed'));
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authenticationRepository.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Sign out failed'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSendPasswordResetEmailRequested(
    AuthSendPasswordResetEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authenticationRepository.sendPasswordResetEmail(
        email: event.email,
      );
      emit(const AuthPasswordResetEmailSent());
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Password reset failed'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSendVerificationEmailRequested(
    AuthSendVerificationEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authenticationRepository.sendVerificationEmail();
      emit(const AuthVerificationEmailSent());
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Failed to send verification email'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
