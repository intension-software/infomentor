import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          _errorMessage = 'Nesprávne prihlasovacie meno alebo heslo';
          _emailBorderColor = Theme.of(context).colorScheme.error;
          _passwordBorderColor = Theme.of(context).colorScheme.error;
        });
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).primaryColor,
    body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Container(
              child: SvgPicture.asset(
                'assets/logo.svg',
                width: 200,
              ),
              padding: EdgeInsets.all(16),
            ),
            Expanded(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Prihlásenie',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        SizedBox(height: 100),
                        reTextField(
                          "Vložte email",
                          false,
                          _emailTextController,
                          _emailBorderColor,
                        ),
                        SizedBox(height: 8),
                        reTextField(
                          "Vložte heslo",
                          true,
                          _passwordTextController,
                          _passwordBorderColor,
                        ),
                        SizedBox(height: 8),
                        _errorMessage != null
                            ? Container(
                                width: 300,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.getColor('red').lighter,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: AppColors.getColor('red').main,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 8),
                        Text(
                          'Ak prihlasovacie údaje nemáš, vypýtaj ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        Text(
                          'si ich od svojho vyučujúceho ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ReButton(
              activeColor: AppColors.getColor('green').main,
              defaultColor: AppColors.getColor('green').light,
              disabledColor: AppColors.getColor('mono').lightGrey,
              focusedColor: AppColors.getColor('primary').lighter,
              hoverColor: AppColors.getColor('green').main,
              text: 'PRIHLÁSIŤ',
              onTap: handleLogin,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}

}