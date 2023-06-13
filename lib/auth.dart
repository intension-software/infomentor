import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future <void> signIn(String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}