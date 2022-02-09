import 'package:firebase_auth/firebase_auth.dart';

class AuthenticatorController {
  final _firebaseAuth = FirebaseAuth.instance;

  User? get user => _firebaseAuth.currentUser;

  Stream<User?> get userStream => _firebaseAuth.userChanges();

  Future<void> toggleLogin() async {
    if (user == null) {
      await _firebaseAuth.signInAnonymously();
    } else {
      await _firebaseAuth.signOut();
    }
  }
}
