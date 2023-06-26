import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  Color _emailBorderColor = Colors.white;
  Color _passwordBorderColor = Colors.white;
  String? _errorMessage;

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  handleLogin() async {
    final email = _emailTextController.value.text;
    final password = _passwordTextController.value.text;

    // Perform validation
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _errorMessage = null;
        _emailBorderColor = Colors.white;
        _passwordBorderColor = Colors.white;
      });

      try {
        // Call your login function here
        // Replace the 'signIn' method with your actual authentication logic
        await Auth().signIn(email, password);
      } catch (error) {
        setState(() {
          _loading = false;
          _errorMessage = 'Invalid email or password. Please try again.';
          _emailBorderColor = Colors.red;
          _passwordBorderColor = Colors.red;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                reTextField("Vložte email", false, _emailTextController, _emailBorderColor),
                reTextField("Vložte heslo", true, _passwordTextController, _passwordBorderColor),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                reButton(
                  context,
                  "PRIHLÁSIŤ SA",
                  0xff3cad9a,
                  0xffffffff,
                  0xffffffff,
                  handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
