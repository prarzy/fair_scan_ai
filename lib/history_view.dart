import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  // Mock data list
  List<Map<String, String>> historyItems = [
    {"name": "terms_v2.pdf", "date": "17 Mar 2026", "score": "42"},
    {"name": "privacy_policy.pdf", "date": "15 Mar 2026", "score": "12"},
    {"name": "eula_draft.pdf", "date": "10 Mar 2026", "score": "85"},
  ];

  void _showSummary(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(item['name']!, style: const TextStyle(color: Colors.white)),
        content: Text("Risk Score: ${item['score']}\nDetailed scan results would be displayed here.", style: const TextStyle(color: AppColors.secondaryBrand)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE", style: TextStyle(color: AppColors.accentNeon))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Scan History", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return InkWell(
                  onTap: () => _showSummary(context, item),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.description_outlined, color: AppColors.accentNeon),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text("Scanned: ${item['date']}", style: const TextStyle(color: AppColors.secondaryBrand, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                          onPressed: () => setState(() => historyItems.removeAt(index)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}