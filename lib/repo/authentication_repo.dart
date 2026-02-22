import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:songquest/config/app_config.dart';
import 'package:songquest/helper/http.dart';
import 'package:songquest/helper/logger.dart';

class AuthenticationRepository {
  AuthenticationRepository({firebase_auth.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  Stream<firebase_auth.User?> get user => _firebaseAuth.authStateChanges();

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  Future<firebase_auth.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw firebase_auth.FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<firebase_auth.UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) async {
    firebase_auth.UserCredential? userCredential;

    try {
      Logger.instance.d(
        'email: ${email}, password: ${password}, fullName: ${fullName}, phone: ${phone}, role: $role',
      );

      // Create user account in Firebase
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get Firebase ID token for backend authentication
      final idToken = await userCredential.user?.getIdToken();

      Logger.instance.d('idToken: $idToken');

      final url = AppConfig.registerUrl;
      Logger.instance.d('AppConfig.registerUrl: $url');

      // Create user in backend database
      await HttpClient.postJSON(
        AppConfig.registerUrl,
        data: {'idToken': idToken, 'name': fullName, 'email': email, 'mobile': phone, 'role': role},
      );

      Logger.instance.d('User created in backend database');

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      Logger.instance.d('Email verification sent');

      // Sign out user to prevent automatic login before verification
      await _firebaseAuth.signOut();

      Logger.instance.d('User signed out after registration');

      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      Logger.instance.e('Firebase auth error signing up: ${e.toString()}');
      throw firebase_auth.FirebaseAuthException(code: e.code, message: e.message);
    } on DioException catch (e) {
      // ROLLBACK: Delete Firebase user if backend fails to maintain consistency
      if (userCredential?.user != null) {
        try {
          Logger.instance.w('Backend failed, rolling back Firebase user creation');
          await userCredential!.user!.delete();
          Logger.instance.d('Firebase user deleted successfully during rollback');
        } catch (deleteError) {
          Logger.instance.e(
            'Failed to delete Firebase user during rollback: ${deleteError.toString()}',
          );
          // Log the orphan account for manual cleanup
          Logger.instance.e(
            'ORPHAN ACCOUNT: Firebase user exists but backend failed. Email: $email, Phone: $phone',
          );
        }
      }

      // Extract error message from backend response if available
      final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Failed to create account';
      Logger.instance.e('Backend API error during signup: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      // ROLLBACK: Delete Firebase user if any unexpected error occurs
      if (userCredential?.user != null) {
        try {
          Logger.instance.w('Unexpected error, rolling back Firebase user creation');
          await userCredential!.user!.delete();
          Logger.instance.d('Firebase user deleted successfully during rollback');
        } catch (deleteError) {
          Logger.instance.e(
            'Failed to delete Firebase user during rollback: ${deleteError.toString()}',
          );
          Logger.instance.e(
            'ORPHAN ACCOUNT: Firebase user exists but signup failed. Email: $email, Phone: $phone',
          );
        }
      }

      Logger.instance.e('Unexpected error during signup: ${e.toString()}');
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Future<firebase_auth.UserCredential?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) return null;

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final credential = firebase_auth.GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     return await _firebaseAuth.signInWithCredential(credential);
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     throw firebase_auth.FirebaseAuthException(
  //       code: e.code,
  //       message: e.message,
  //     );
  //   }
  // }

  // Future<firebase_auth.UserCredential?> signInWithFacebook() async {
  //   try {
  //     final LoginResult loginResult = await FacebookAuth.instance.login();
  //     if (loginResult.accessToken == null) return null;

  //     final credential = firebase_auth.FacebookAuthProvider.credential(
  //       loginResult.accessToken!.tokenString,
  //     );

  //     return await _firebaseAuth.signInWithCredential(credential);
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     throw firebase_auth.FirebaseAuthException(
  //       code: e.code,
  //       message: e.message,
  //     );
  //   }
  // }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw firebase_auth.FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw firebase_auth.FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw firebase_auth.FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  /// Get the Firebase ID token for the current user
  /// This token will be used for API authentication
  Future<String?> getFirebaseToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return await user.getIdToken();
      }
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw firebase_auth.FirebaseAuthException(code: e.code, message: e.message);
    }
  }
}
