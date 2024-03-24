import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthHelper {

  AuthHelper();

  Future<UserCredential> loginWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
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
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    return FirebaseAuth.instance.authStateChanges().map((event) => event != null);
  }

  bool isSignedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  String? getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> logout() async {
    try {
      return await FirebaseAuth.instance.signOut();
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
