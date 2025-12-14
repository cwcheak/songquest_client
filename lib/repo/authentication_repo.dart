import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
  }) async {
    try {
      // Create user account
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Sign out user to prevent automatic login before verification
      await _firebaseAuth.signOut();

      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw firebase_auth.FirebaseAuthException(code: e.code, message: e.message);
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
}
