# dark_pattern_detector

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## OCR Part 1 Setup (Member C)

1. Install dependencies:
	- `flutter pub get`
2. Create env file for Cloud Vision fallback:
	- Copy `.env.example` to `.env`
	- Set `CLOUD_VISION_API_KEY` with your Google Cloud Vision API key
3. Keep `.env` out of source control:
	- `.env` is already listed in `.gitignore`

### What is implemented

- `lib/models/match_snapshot.dart`
- `lib/services/ocr_service.dart`

`OcrService.processFrame(Uint8List frameBytes)` runs ML Kit OCR first, then falls
back to Cloud Vision when confidence is low, and parses:

- `homeTeam`
- `awayTeam`
- `score`
- `clock`
- `hasOverlay`

### Parser verification

Run:

- `flutter test test/ocr_service_test.dart`

### Part 1 status

Part 1 is complete and validated on static scoreboard images:

- `assets/test_scoreboards/epl_01.png`
- `assets/test_scoreboards/epl_02.png`
- `assets/test_scoreboards/nba_01.png`
- `assets/test_scoreboards/ucl_01.png`
