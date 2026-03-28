class ViolationAlert {
  final String severity; // e.g., "HIGH RISK", "MEDIUM", "LOW"
  final String description; // Gemini-generated description
  final DateTime timestamp;
  final String fieldMismatch; // Which field was wrong (e.g., "score", "clock")

  const ViolationAlert({
    required this.severity,
    required this.description,
    required this.timestamp,
    required this.fieldMismatch,
  });

  @override
  String toString() {
    return 'ViolationAlert(severity: $severity, description: $description, timestamp: $timestamp, fieldMismatch: $fieldMismatch)';
  }
}
