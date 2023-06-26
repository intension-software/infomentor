import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  handleLogin() async {
    final email = _emailTextController.value.text;
    final password = _passwordTextController.value.text;
    await Auth().signIn(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          reTextField("Vložte email", false, _emailTextController),
          reTextField("Vložte heslo", true, _passwordTextController),
          reButton(context, "PRIHLÁSIŤ SA", 0xff3cad9a, 0xffffffff, 0xffffffff, handleLogin)
        ],
      ),
    ));
  }
}
