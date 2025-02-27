import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges {
    print('Listening to auth state changes');
    return _firebaseAuth.authStateChanges();
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    print('Signing in with email and password');
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    print('Creating user with email and password');
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    print('Signing out');
    await _firebaseAuth.signOut();
  }
}