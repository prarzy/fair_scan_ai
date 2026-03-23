// Quick test to verify parser fixes before running full flutter test
import 'dart:io';

import 'package:dark_pattern_detector/services/ocr_service.dart';

void main() {
  final service = OcrService(cloudVisionApiKey: '');

  // Test cases from unit tests
  final tests = [
    ("MAN UTD 2 - 1 CHELSEA 45'",
      {'homeTeam': 'MAN UTD', 'awayTeam': 'CHELSEA', 'score': '2 - 1', 'clock': "45'"}),
    ('LAL 101 - 99 BOS 1:23',
      {'homeTeam': 'LAL', 'awayTeam': 'BOS', 'score': '101 - 99', 'clock': '1:23'}),
    ('MCI 0 0 TOT 89:10',
      {'homeTeam': 'MCI', 'awayTeam': 'TOT', 'score': '0 - 0', 'clock': '89:10'}),
    ('NOP 107 LAC 124 3rd 2:59 :24',
      {'homeTeam': 'NOP', 'awayTeam': 'LAC', 'score': '107 - 124', 'clock': '2:59'}),
  ];

  int passed = 0;
  int failed = 0;

  for (final test in tests) {
    final input = test.$1;
    final expected = test.$2;
    final result = service.parseOcrString(input);

    final homeMatch = result.homeTeam == expected['homeTeam'];
    final awayMatch = result.awayTeam == expected['awayTeam'];
    final scoreMatch = result.score == expected['score'];
    final clockMatch = result.clock == expected['clock'];

    if (homeMatch && awayMatch && scoreMatch && clockMatch) {
      stdout.writeln('✓ PASS: $input');
      passed++;
    } else {
      stdout.writeln('✗ FAIL: $input');
      if (!homeMatch) stdout.writeln('  homeTeam: got "${result.homeTeam}", wanted "${expected['homeTeam']}"');
      if (!awayMatch) stdout.writeln('  awayTeam: got "${result.awayTeam}", wanted "${expected['awayTeam']}"');
      if (!scoreMatch) stdout.writeln('  score: got "${result.score}", wanted "${expected['score']}"');
      if (!clockMatch) stdout.writeln('  clock: got "${result.clock}", wanted "${expected['clock']}"');
      failed++;
    }
  }

  stdout.writeln('\n$passed passed, $failed failed');
}
