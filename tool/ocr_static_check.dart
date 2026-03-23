import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:dark_pattern_detector/services/ocr_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiKey = await _readCloudVisionApiKey();
  stdout.writeln('CLOUD_VISION_API_KEY present: ${apiKey.isNotEmpty}');

  final service = OcrService(
    cloudVisionApiKey: apiKey,
    enableDebugLogs: true,
  );

  final imagePaths = [
    'assets/test_scoreboards/epl_01.png',
    'assets/test_scoreboards/epl_02.png',
    'assets/test_scoreboards/nba_01.png',
    'assets/test_scoreboards/ucl_01.png',
  ];

  for (final path in imagePaths) {
    final file = File(path);
    if (!await file.exists()) {
      stdout.writeln('Missing image: $path');
      continue;
    }

    final bytes = await file.readAsBytes();
    final snapshot = await service.processFrame(bytes);
    stdout.writeln('--- $path ---');

    // Also directly call parseOcrString to debug what parser sees
    final rawText = await service.debugGetRawOcrText(bytes);
    stdout.writeln('Raw OCR text: "$rawText"');

    stdout.writeln('Parsed: $snapshot');
  }

  await service.dispose();
}

Future<String> _readCloudVisionApiKey() async {
  File? envFile;

  var dir = Directory.current;
  while (true) {
    final pubspec = File('${dir.path}${Platform.pathSeparator}pubspec.yaml');
    final candidateEnv = File('${dir.path}${Platform.pathSeparator}.env');

    if (await pubspec.exists()) {
      if (await candidateEnv.exists()) {
        envFile = candidateEnv;
      }
      break;
    }

    if (dir.path == dir.parent.path) {
      break;
    }
    dir = dir.parent;
  }

  if (envFile == null || !await envFile.exists()) {
    stdout.writeln('Could not find .env near project root from ${Directory.current.path}');
    return '';
  }

  stdout.writeln('Using .env at ${envFile.path}');
  final lines = await envFile.readAsLines();
  for (final rawLine in lines) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) {
      continue;
    }

    final idx = line.indexOf('=');
    if (idx <= 0) {
      continue;
    }

    final key = line.substring(0, idx).trim();
    if (key != 'CLOUD_VISION_API_KEY') {
      continue;
    }

    final value = line.substring(idx + 1).trim();
    if (value.startsWith('"') && value.endsWith('"') && value.length >= 2) {
      return value.substring(1, value.length - 1);
    }
    return value;
  }

  return '';
}
