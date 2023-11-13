import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future <void> signIn(String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}

// New function to check if email is already in use
Future<bool> isEmailAlreadyUsed(String email) async {
  try {
    final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    // If list is empty, email is not used yet
    return list.isNotEmpty;
  } on FirebaseAuthException catch (e) {
    print('Firebase Auth Exception: $e');
    return false; // or handle the exception as needed
  }
}

