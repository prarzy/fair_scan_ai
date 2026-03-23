import 'package:dark_pattern_detector/services/ocr_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OcrService.parseOcrString', () {
    final service = OcrService(cloudVisionApiKey: '');

    test('extracts score and clock from standard scoreboard text', () {
      final snapshot = service.parseOcrString(
        "MAN UTD 2 - 1 CHELSEA 45'",
      );

      expect(snapshot.homeTeam, 'MAN UTD');
      expect(snapshot.awayTeam, 'CHELSEA');
      expect(snapshot.score, '2 - 1');
      expect(snapshot.clock, "45'");
      expect(snapshot.hasOverlay, isFalse);
    });

    test('extracts clock in mm:ss format', () {
      final snapshot = service.parseOcrString(
        'LAL 101 - 99 BOS 1:23',
      );

      expect(snapshot.score, '101 - 99');
      expect(snapshot.clock, '1:23');
    });

    test('extracts score when scoreboard uses space-separated digits', () {
      final snapshot = service.parseOcrString(
        'MCI 0 0 TOT 89:10',
      );

      expect(snapshot.homeTeam, 'MCI');
      expect(snapshot.awayTeam, 'TOT');
      expect(snapshot.score, '0 - 0');
      expect(snapshot.clock, '89:10');
    });

    test('extracts EPL teams correctly with noisy banner text', () {
      final snapshot = service.parseOcrString(
        "MCI 0 0 TOT 89:10 THE WORLD'S GAME",
      );

      expect(snapshot.homeTeam, 'MCI');
      expect(snapshot.awayTeam, 'TOT');
      expect(snapshot.score, '0 - 0');
      expect(snapshot.clock, '89:10');
    });

    test('extracts EPL teams and score with clock between score digits', () {
      final snapshot = service.parseOcrString(
        "MCI HESTER 0 89:10 0 TOT HE WORLD'S GAME FC24 MANCHE THE WORLD'S",
      );

      expect(snapshot.homeTeam, 'MCI');
      expect(snapshot.awayTeam, 'TOT');
      expect(snapshot.score, '0 - 0');
      expect(snapshot.clock, '89:10');
    });

    test('extracts UCL teams and score from compact format', () {
      final snapshot = service.parseOcrString(
        '90:00 RMA 2 | 1 BAY (4-3) 9:34 +9',
      );

      expect(snapshot.homeTeam, 'RMA');
      expect(snapshot.awayTeam, 'BAY');
      expect(snapshot.score, '2 - 1');
      expect(snapshot.clock, '90:00');
    });

    test('extracts short clock format like :24', () {
      final snapshot = service.parseOcrString(
        'NOP 107 LAC 124 3rd 2:59 :24',
      );

      expect(snapshot.score, '107 - 124');
      expect(snapshot.clock, '2:59');
    });

    test('marks overlay when suspicious URL or phone data is present', () {
      final snapshot = service.parseOcrString(
        "ARS 1 - 0 CITY 90+3' visit www.fake-stream.com or +12345678901",
      );

      expect(snapshot.hasOverlay, isTrue);
    });
  });
}
