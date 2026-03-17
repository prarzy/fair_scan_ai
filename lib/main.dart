import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'login_view.dart'; // Make sure this file exists in /lib
import 'analysis_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RightsGuardApp());
}

class RightsGuardApp extends StatelessWidget {
  const RightsGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FairScan AI', // Updated Title
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primaryBrand,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: AppColors.background,
      ),
      // Starts the app at the login screen
      home: const LoginView(), 
    );
  }
}