import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/theme/app_theme.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  bool _isScanning = false;
  String? _fileName;

  void _startScan() async {
    if (_fileName == null) return;
    setState(() => _isScanning = true);
    
    // Simulate AI processing time
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() => _isScanning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBrand, // Use the new Midnight color
      body: Row(
        children: [
          // --- SIDEBAR ---
          Container(
            width: 260,
            color: const Color(0xFF090C10), // Slightly darker for the sidebar
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shield_rounded, color: AppColors.accentNeon, size: 28),
                    SizedBox(width: 12),
                    Text("FAIRSCAN AI", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 0.5, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 48),
                _sidebarItem(Icons.analytics_rounded, "Analyze Document", true),
                _sidebarItem(Icons.history_rounded, "Scan History", false),
                _sidebarItem(Icons.gavel_rounded, "Legal Database", false),
                const Spacer(),
                const Divider(color: Colors.white10, height: 40),
                _sidebarItem(Icons.account_circle_outlined, "Prarthana Upadhyaya", false),
                _sidebarItem(Icons.logout_rounded, "Sign Out", false),
              ],
            ),
          ),

          // --- MAIN CONTENT AREA ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: [
                  // DOCUMENT PREVIEW AREA
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            if (_fileName == null)
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined, size: 80, color: AppColors.secondaryBrand.withValues(alpha: 0.2)),
                                    const SizedBox(height: 16),
                                    const Text("Drop contract or PDF here", style: TextStyle(fontSize: 18, color: AppColors.secondaryBrand)),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () => setState(() => _fileName = "terms_of_service_v2.pdf"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentNeon,
                                        foregroundColor: AppColors.primaryBrand,
                                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                      ),
                                      child: const Text("BROWSE FILES", style: TextStyle(fontWeight: FontWeight.w900)),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.description_rounded, size: 100, color: Colors.white24),
                                    const SizedBox(height: 12),
                                    Text(_fileName!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                                    Text(_isScanning ? "AI Analyzing Content..." : "Analysis Complete", 
                                      style: TextStyle(color: _isScanning ? AppColors.accentNeon : AppColors.secondaryBrand)),
                                  ],
                                ),
                              ),
                            
                            // The Scanning Overlay
                            if (_isScanning)
                              Positioned.fill(
                                child: Container(
                                  color: AppColors.primaryBrand.withValues(alpha: 0.6),
                                  child: Lottie.asset('assets/animations/scan_effect.json', fit: BoxFit.contain),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 32),

                  // ANALYSIS SIDE PANEL (Fixed Overflow with SingleChildScrollView)
                  Container(
                    width: 400,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: _buildAnalysisPanel(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accentNeon.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppColors.accentNeon : AppColors.secondaryBrand, size: 22),
        title: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.secondaryBrand, fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
        onTap: () {},
      ),
    );
  }

  Widget _buildAnalysisPanel() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Audit Results", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1)),
                const Text("CCPA 2023 Compliance Check", style: TextStyle(color: AppColors.secondaryBrand, fontSize: 14)),
                const SizedBox(height: 48),
                
                // Tech Score Dial
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 160, width: 160,
                        child: CircularProgressIndicator(
                          value: _isScanning ? null : 0.42,
                          strokeWidth: 8,
                          backgroundColor: AppColors.border,
                          color: AppColors.danger,
                        ),
                      ),
                      Column(
                        children: [
                          Text(_isScanning ? "--" : "42", style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text("RISK SCORE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.danger)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),
                const Text("VIOLATIONS", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.secondaryBrand, letterSpacing: 1)),
                const SizedBox(height: 16),
                _violationCard("Basket Sneaking", "Clause 4.2", AppColors.danger),
                const SizedBox(height: 12),
                _violationCard("Forced Continuity", "Clause 7.1", AppColors.warning),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        
        // Fixed Action Button
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ElevatedButton(
            onPressed: _fileName != null && !_isScanning ? _startScan : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentNeon,
              foregroundColor: AppColors.primaryBrand,
              disabledBackgroundColor: AppColors.border,
              minimumSize: const Size.fromHeight(64),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _isScanning 
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: AppColors.primaryBrand, strokeWidth: 2))
              : const Text("INITIALIZE SCAN", style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ),
      ],
    );
  }

  Widget _violationCard(String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.7), fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}