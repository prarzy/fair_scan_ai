import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'analysis_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBrand,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_rounded, color: AppColors.accentNeon, size: 64),
              const SizedBox(height: 24),
              const Text("FAIRSCAN AI", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const Text("Consumer Protection Suite", style: TextStyle(color: AppColors.secondaryBrand)),
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: AppColors.secondaryBrand),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.accentNeon), borderRadius: BorderRadius.circular(12)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AnalysisView())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentNeon,
                  foregroundColor: AppColors.primaryBrand,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("SIGN IN", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}