import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Color(0xff4b4fb3)),
      child: Column(
        children: <Widget>[
          reTextField("Vložte email", false, _emailTextController),
          reTextField("Vložte heslo", true, _passwordTextController),
          reButton(context, "PRIHLÁSIŤ SA", 0xff3cad9a, 0xffffffff, 0xffffffff, () {
            FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailTextController.text, 
              password: _passwordTextController.text)
            .then((value) {
              Navigator.pushNamed(context, '/');
            });
          })
        ],
      ),
    ));
  }
}
