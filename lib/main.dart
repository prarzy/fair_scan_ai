import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'analysis_view.dart';

void main() {
  // Ensure Flutter is ready before launching
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RightsGuardApp());
}

class RightsGuardApp extends StatelessWidget {
  const RightsGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the red 'Debug' banner
      title: 'RightsGuard AI',
      
      // Use the high-end theme we created in AppTheme
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primaryBrand,
        
        // Use 'Inter' or 'Manrope' for that clean, modern look
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        
        // Professional apps use white or very light grey backgrounds
        scaffoldBackgroundColor: AppColors.background,
      ),
      
      // Points the app to your new, cool dashboard
      home: const AnalysisView(),
    );
  }
}