import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
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
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
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
    emit(const AuthLoading());
    try {
      await _authenticationRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
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

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
