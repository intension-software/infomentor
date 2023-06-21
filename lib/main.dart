import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:infomentor/screens/Home.dart';
import 'package:infomentor/screens/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCKxORmtJ4yQBMBT87i1tQiw1675VM39II",
      appId: "1:383337818314:web:a6e8c3e5cd1323fee1ac33",
      messagingSenderId: "383337818314",
      projectId: "infomentor-d71f7",
    ),
  );
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xff4b4fb3),
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator if the authentication state is still loading
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasData) {
                // User is logged in, navigate to the specified screen
                return Home();
              } else {
                // User is not logged in, navigate to Login
                return Login();
              }
            }
          },
        ),
        
    );
  }
}