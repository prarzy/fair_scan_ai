import 'package:flutter/material.dart';
import '../models/violation_alert.dart';
import '../core/theme/app_theme.dart';

/// Alert card widget - displays violation details
/// In Part 1, shows empty card with placeholder text
class AlertCard extends StatelessWidget {
  final ViolationAlert? alert;

  const AlertCard({
    super.key,
    this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: alert != null ? AppColors.danger.withValues(alpha: 0.2) : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: alert == null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 48,
                        color: AppColors.accentNeon.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No active violations',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.secondaryBrand,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Severity badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _severityColor(alert!.severity).withValues(alpha: 0.15),
                      border: Border.all(
                        color: _severityColor(alert!.severity),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      alert!.severity,
                      style: TextStyle(
                        color: _severityColor(alert!.severity),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryBrand,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    alert!.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Timestamp
                  Text(
                    'Timestamp',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryBrand,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    alert!.timestamp.toString().split('.')[0],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                          fontFamily: 'monospace',
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Field mismatch
                  Text(
                    'Mismatched Field',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryBrand,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.08),
                      border: Border.all(
                        color: AppColors.danger.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      alert!.fieldMismatch,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.danger,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color _severityColor(String severity) {
    return switch (severity.toUpperCase()) {
      'HIGH RISK' || 'HIGH' => AppColors.danger,
      'MEDIUM' => AppColors.warning,
      'LOW' => const Color(0xFF6A994E),
      _ => AppColors.secondaryBrand,
    };
  }
}
