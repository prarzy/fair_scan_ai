import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Mock frame sampler for testing Part 1 UI
/// Generates a static test image that refreshes every 5 seconds
class MockFrameSampler {
  Timer? _timer;
  final _frameController = StreamController<Uint8List>.broadcast();

  /// Start sampling frames from a given URL
  /// Returns a stream of frame data (Uint8List)
  Stream<Uint8List> startSampling(String url) {
    // Cancel any existing timer
    _timer?.cancel();

    // Generate initial frame
    _emitTestFrame();

    // Emit a new frame every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _emitTestFrame();
    });

    return _frameController.stream;
  }

  /// Stop sampling
  void stopSampling() {
    _timer?.cancel();
  }

  /// Save current frame (stub - just prints to console in Part 1)
  Future<void> saveCurrentFrame() async {
    debugPrint('[MockFrameSampler] saveCurrentFrame called - no-op stub for Part 1');
  }

  /// Generate a simple test frame with a colored canvas
  Future<void> _emitTestFrame() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const width = 800.0;
    const height = 600.0;

    // Draw a simple gradient background
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(width, height),
        [Colors.blue.shade900, Colors.purple.shade900],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    // Draw text "Live Feed - Mock Frame"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Live Feed - Mock Frame',
        style: TextStyle(color: Colors.white, fontSize: 32),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(width / 2 - 200, height / 2 - 50));

    // Draw timestamp
    final timestamp = DateTime.now().toString().split('.')[0];
    final timestampPainter = TextPainter(
      text: TextSpan(
        text: 'Updated: $timestamp',
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    timestampPainter.layout();
    timestampPainter.paint(canvas, const Offset(20, height - 50));

    final image = await pictureRecorder.endRecording().toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    _frameController.add(pngBytes);
  }

  void dispose() {
    _timer?.cancel();
    _frameController.close();
  }
}
