import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dark_pattern_detector/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const RightsGuardApp());

    // Just check that something renders
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}