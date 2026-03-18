class ScanRecord {
  final String fileName;
  final String scannedDate;
  final String extractedText;
  final int blockCount;
  final bool isPdf;

  ScanRecord({
    required this.fileName,
    required this.scannedDate,
    required this.extractedText,
    required this.blockCount,
    required this.isPdf,
  });
}