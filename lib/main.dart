import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:infomentor/screens/Home.dart';
import 'package:infomentor/screens/Login.dart';
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
      apiKey: apiKey,
      authDomain: authDomain,
      projectId: projectId,
      storageBucket: storageBucket,
      messagingSenderId: messagingSenderId,
      appId: appId,
      measurementId: measerumentId
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
          // SECONDARY
          primaryContainer: AppColors.primary.light,
          onPrimaryContainer: AppColors.mono.white,
          onPrimary: AppColors.mono.white,
          background: AppColors.mono.white,
          onBackground: AppColors.mono.black,
          error: AppColors.red.main,
          // Add more custom colors as needed
        ),

        // Define the default font family.
        fontFamily: GoogleFonts.inter().fontFamily,

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),


          headlineLarge: TextStyle(fontSize: 24, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 20, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 16, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.bold),

          labelLarge: TextStyle(fontSize: 16),
          labelMedium: TextStyle(fontSize: 14),
          labelSmall: TextStyle(fontSize: 12),

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
              return Login();
            }
          }
        },
      ),
    );
  }
}