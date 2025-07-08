import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  User? get currentUser => _firebaseAuth.currentUser;
  // ignore: non_constant_identifier_names
  Stream<User?> get AuthStateChanges=>  _firebaseAuth.authStateChanges();


  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }


  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Çıkış yap
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}


