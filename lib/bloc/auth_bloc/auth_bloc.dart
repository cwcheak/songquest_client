import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:songquest/helper/logger.dart';
import 'package:songquest/repo/authentication_repo.dart';
import 'package:songquest/helper/http.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository authenticationRepository;
  late final StreamSubscription<firebase_auth.User?> _userSubscription;

  AuthBloc({required this.authenticationRepository}) : super(const AuthChecking()) {
    // Register event handlers first
    on<AuthUserChanged>(_onUserChanged);
    on<AuthSignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<AuthSignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    // on<AuthSignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    // on<AuthSignInWithFacebookRequested>(_onSignInWithFacebookRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthSendPasswordResetEmailRequested>(_onSendPasswordResetEmailRequested);
    on<AuthSendVerificationEmailRequested>(_onSendVerificationEmailRequested);

    // Listen to authentication state changes
    _userSubscription = authenticationRepository.user.listen((user) => add(AuthUserChanged(user)));
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    Logger.instance.d("_onUserChanged: event.firebaseUser: ${event.firebaseUser}");
    if (event.firebaseUser != null) {
      Sentry.captureMessage(
        "User '${event.firebaseUser!.email}' logged in",
        level: SentryLevel.debug,
      );
      // Set up Firebase auth interceptor when user is authenticated
      HttpClient.setAuthRepository(authenticationRepository);
      emit(AuthAuthenticated(event.firebaseUser!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignInWithEmailRequested(
    AuthSignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    Logger.instance.d(
      "_onSignInWithEmailRequested: Email: ${event.email} | Password: ${event.password}",
    );
    Sentry.captureMessage("User '${event.email}' is logging in...", level: SentryLevel.debug);

    emit(const AuthLoading());
    try {
      Logger.instance.d("Start _onSignInWithEmailRequested....");
      final userCredential = await authenticationRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      // Logger.instance.d("Completed _onSignInWithEmailRequested....");

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await authenticationRepository.signOut();
        Logger.instance.i("User '${event.email}' failed to login. Reason: Email is not verified.");
        Sentry.captureMessage(
          "User '${event.email}' failed to login. Reason: Email is not verified.",
          level: SentryLevel.error,
        );
        emit(const AuthFailure('Please verify your email before logging in.'));
      } else {
        Sentry.captureMessage(
          "User '${event.email}' successfully logged in.",
          level: SentryLevel.info,
        );
        Logger.instance.i("User '${event.email}' successfully logged in.");
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'user-disabled' => 'This account has been disabled. Please contact the administrator.',
        'user-not-found' => 'User ${event.email} not found.',
        'network-request-failed' => 'No internet connection.',
        _ => 'Unable to sign in. Please check your email or password.',
      };

      Logger.instance.e("User '${event.email}' failed to login. Reason: ${e.code}");

      Sentry.captureMessage(
        "User '${event.email}' failed to login. Reason: ${e.code}",
        level: SentryLevel.error,
      );

      emit(AuthFailure(message));
    } catch (e) {
      Logger.instance.e("_onSignInWithEmailRequested catch: e.toString: ${e.toString()}");
      Sentry.captureMessage(
        "User '${event.email}' failed to login. Exception: ${e.toString()}",
        level: SentryLevel.error,
      );
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignUpWithEmailRequested(
    AuthSignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    Logger.instance.d("Start _onSignUpWithEmailRequested....");
    emit(const AuthLoading());
    try {
      await authenticationRepository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        phone: event.phone,
        role: event.role,
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

  Future<void> _onSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await authenticationRepository.signOut();
      // Remove Firebase authentication interceptor when user signs out
      HttpClient.removeAuthInterceptor();
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
      await authenticationRepository.sendPasswordResetEmail(email: event.email);
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
    try {
      await authenticationRepository.sendVerificationEmail();
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
