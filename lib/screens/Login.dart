import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:infomentor/widgets/SchoolForm.dart';
import 'package:flutter/gestures.dart'; // Import this line
import 'dart:html' as html;

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
  bool _isEnterScreen = true;
  bool _isVisible = true;
  bool isMobile = false;
  bool isDesktop = false;
  bool isSchool = false;

  final userAgent = html.window.navigator.userAgent.toLowerCase();

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    isMobile = userAgent.contains('mobile');
    isDesktop = userAgent.contains('macintosh') ||
        userAgent.contains('windows') ||
        userAgent.contains('linux');
  }

  int _loginAttempts = 0;
  bool _showCaptcha = false;

  toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  handleLogin() async {
    final email = _emailTextController.value.text;
    final password = _passwordTextController.value.text;

    // Check if the CAPTCHA is enabled
    /*if (_showCaptcha) {
      // Verify the CAPTCHA
      final result = await recaptchaV3Controller.verify();
      if (result != null && result.isSuccess) {
        // CAPTCHA verified successfully, proceed with login
        _loginAttempts = 0; // Reset login attempts
        _showCaptcha = false; // Hide CAPTCHA
        setState(() {});
        await Auth().signIn(email, password); // Perform login
      } else {
        // CAPTCHA verification failed
        // Handle the failure, show an error message, etc.
      }
      return;
    }*/

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

        // Check if the login attempts exceed 10
        _loginAttempts++;
        if (_loginAttempts >= 10) {
          // Show the CAPTCHA
          setState(() {
            _showCaptcha = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEnterScreen)
      return Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: SvgPicture.asset('assets/logo.svg', width: 500),
                  ),
                ],
              ),
            ),
            Center(
              child: ReButton(
                activeColor: AppColors.getColor('mono').white,
                defaultColor: AppColors.getColor('mono').white,
                disabledColor: AppColors.getColor('mono').lightGrey,
                focusedColor: AppColors.getColor('primary').light,
                hoverColor: AppColors.getColor('mono').lighterGrey,
                textColor: AppColors.getColor('mono').black,
                iconColor: AppColors.getColor('mono').black,
                text: 'PRIHLÁSENIE',
                bold: true,
                onTap: () {
                  setState(() {
                    _isEnterScreen = false;
                  });
                },
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      );

    if (isSchool) return SchoolForm(isSchool: () {setState(() {
      isSchool = false;
    }); });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height <= 700
          ? 700
          : MediaQuery.of(context).size.height >= 900
              ? 900
              : MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 60),
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  width:  isMobile ? 132 : 172,
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
                          Container(
                            margin: EdgeInsets.only(top: 100, bottom: 4, right: 4, left: 4),
                              child:reTextField(
                              "Email",
                              false,
                              _emailTextController,
                              _emailBorderColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(4),
                            child:  reTextField(
                              "Heslo",
                              true,
                              _passwordTextController,
                              _passwordBorderColor,
                              visibility: _isVisible,
                              toggle: toggleVisibility
                            ),
                          ),
                          _errorMessage != null
                            ? Container(
                                margin: EdgeInsets.only(top: 22),
                                width: 300,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.getColor('red').lighter,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 20,),
                                       SvgPicture.asset('assets/icons/smallErrorIcon.svg', color: Theme.of(context).colorScheme.error, height: 16,),
                                      Flexible( // Use Flexible to allow text wrapping
                                        child: Container(
                                          margin: EdgeInsets.all(12),
                                          child: Text(
                                          _errorMessage!,
                                          style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: Theme.of(context).colorScheme.error,
                                            ),
                                          )
                                        ),
                                      ),
                                        SizedBox(width: 8,)
                                    ],
                                  ),
                                ),
                              )
                            : Container(),

                          /*if (_showCaptcha)
                            RecaptchaV3(
                              controller: recaptchaV3Controller,
                              onVerified: (response) {
                                // CAPTCHA verified successfully
                                // You can access response.token here
                                handleLogin();
                              },
                              onError: (e) {
                                // Handle CAPTCHA verification error
                                // For example: _showSnackBar('CAPTCHA verification failed');
                              },
                            ),*/
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Text(
                              'Ak prihlasovacie údaje nemáš, vypýtaj ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                          Text(
                            'si ich od svojho vyučujúceho.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'pridať školu',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              // You can also add onTap to make it clickable
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle the tap event here, e.g., open a URL
                                  // You can use packages like url_launcher to launch URLs.
                                  setState(() {
                                    isSchool = true;
                                  });
                                },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 60),
                child: ReButton(
                  activeColor: AppColors.getColor('green').main,
                  defaultColor: AppColors.getColor('green').light,
                  disabledColor: AppColors.getColor('mono').lightGrey,
                  focusedColor: AppColors.getColor('primary').lighter,
                  hoverColor: AppColors.getColor('green').main,
                  text: 'PRIHLÁSIŤ SA',
                  onTap: handleLogin,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
