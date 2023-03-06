import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  static final instance = AuthHelper(FirebaseAuth.instance);
  final FirebaseAuth _auth;

  AuthHelper(this._auth);

  Future<UserCredential> loginWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFound();
      } else {
        throw UnableToLogin();
      }
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUse();
      } else {
        throw UnableToRegister();
      }
    }
  }

  Stream<bool> isSignedInStream() {
    return _auth.authStateChanges().map((event) => event != null);
  }

  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  String? getUserId() {
    return _auth.currentUser?.uid;
  }

  Future<void> logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw UnableToLogout();
    }
  }
}

class UserNotFound implements Exception {}

class UnableToLogin implements Exception {}

class EmailAlreadyInUse implements Exception {}

class UnableToRegister implements Exception {}

class UnableToLogout implements Exception {}
