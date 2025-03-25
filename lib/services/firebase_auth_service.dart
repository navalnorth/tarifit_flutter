import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur de connexion Google: $e");
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}