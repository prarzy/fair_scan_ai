import 'package:flutter/material.dart';
import '../models/violation_alert.dart';
import '../core/theme/app_theme.dart';

/// DMCA log panel widget - displays past violations
/// In Part 1, shows empty list with placeholder text
class DMCALog extends StatelessWidget {
  final List<ViolationAlert> violations;

  const DMCALog({
    super.key,
    required this.violations,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  color: AppColors.accentNeon,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Violation History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: violations.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 40,
                              color: AppColors.secondaryBrand.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No violations detected',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.secondaryBrand,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: violations.length,
                      separatorBuilder: (context, index) => Divider(
                        color: AppColors.border,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final violation = violations[index];
                        return _ViolationLogEntry(violation: violation);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


/// Single violation log entry
class _ViolationLogEntry extends StatelessWidget {
  final ViolationAlert violation;

  const _ViolationLogEntry({required this.violation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Severity indicator (left border)
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: _severityColor(violation.severity),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  violation.fieldMismatch,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  violation.timestamp.toString().split('.')[0],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryBrand.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),

          // Severity badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _severityColor(violation.severity).withValues(alpha: 0.15),
              border: Border.all(
                color: _severityColor(violation.severity),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              violation.severity,
              style: TextStyle(
                color: _severityColor(violation.severity),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
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
