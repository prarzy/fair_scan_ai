import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class DatabaseView extends StatelessWidget {
  const DatabaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Legal Database", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text("Reference for CCPA, GDPR, and Indian Digital Laws", style: TextStyle(color: AppColors.secondaryBrand)),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _lawCard("CCPA 2023", "California Consumer Privacy Act updates regarding dark patterns."),
                _lawCard("GDPR Art. 25", "Data protection by design and by default."),
                _lawCard("DPDP Act 2023", "India's Digital Personal Data Protection framework."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lawCard(String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.accentNeon, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(color: AppColors.secondaryBrand, height: 1.5)),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text("VIEW FULL CLAUSES →", style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}