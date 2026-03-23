import 'dart:io';

import 'package:dark_pattern_detector/services/ocr_service.dart';

void main() {
  final service = OcrService(cloudVisionApiKey: '');

  // Test cases from unit tests
  final testCases = [
    ('MCI 0 0 TOT 89:10', 'homeTeam: MCI, awayTeam: TOT, score: 0 - 0, clock: 89:10'),
    ('NOP 107 LAC 124 3rd 2:59 :24', 'score: 107 - 124, clock: 2:59'),
    ('90:00 RMA 2 1 BAY (4-3) 9:34 +9', 'likely clock: 90:00, score: 2 - 1 (not 9 34)'),
  ];

  stdout.writeln('=== Parser Debug Tests ===\n');

  for (final (input, expected) in testCases) {
    stdout.writeln('Input: "$input"');
    stdout.writeln('Expected (approx): $expected');
    final result = service.parseOcrString(input);
    stdout.writeln('Got: homeTeam="${result.homeTeam}", awayTeam="${result.awayTeam}", '
          'score="${result.score}", clock="${result.clock}"');
    stdout.writeln('---\n');
  }
}
