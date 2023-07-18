import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:infomentor/screens/Home.dart';
import 'package:infomentor/screens/Tutorial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/Colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();

  final apiKey = dotenv.env['API_KEY'] ?? '';
  final authDomain = dotenv.env['AUTH_DOMAIN'] ?? '';
  final projectId = dotenv.env['PROJECT_ID'] ?? '';
  final storageBucket = dotenv.env['STORAGE_BUCKET'] ?? '';
  final messagingSenderId = dotenv.env['MESSAGING_SENDER_ID'] ?? '';
  final appId = dotenv.env['APP_ID'] ?? '';
  final measerumentId = dotenv.env['MEASERUMENT_ID'] ?? '';


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCKxORmtJ4yQBMBT87i1tQiw1675VM39II",
  authDomain: "infomentor-d71f7.firebaseapp.com",
  projectId: "infomentor-d71f7",
  storageBucket: "infomentor-d71f7.appspot.com",
  messagingSenderId: "383337818314",
  appId: "1:383337818314:web:a6e8c3e5cd1323fee1ac33",
  measurementId: "G-DF2Y7P0QX9"
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
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: AppColors.primary.light,
        colorScheme: ColorScheme.light().copyWith(
          primaryContainer: AppColors.primary.light,
          onPrimaryContainer: AppColors.mono.white,
          onPrimary: AppColors.mono.white,
          background: AppColors.mono.white,
          onBackground: AppColors.mono.black,
          error: AppColors.red.main,
        ),

        // Define the default font family.
        fontFamily: GoogleFonts.inter().fontFamily,

        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
          displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          displaySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),

          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),


          headlineLarge: TextStyle(fontSize: 24, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w900),
          headlineMedium: TextStyle(fontSize: 20, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w900),
          headlineSmall: TextStyle(fontSize: 16, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w900),

          labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),

          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
        ),
      ), // Apply your custom theme
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
              return Tutorial();
            }
          }
        },
      ),
    );
  }
}