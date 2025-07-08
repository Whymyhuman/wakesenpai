import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart';

void main() {
  testWidgets('WakeSenpai app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the home screen loads
    expect(find.text('Selamat datang di WakeSenpai!'), findsOneWidget);
    expect(find.text('Lihat Alarm'), findsOneWidget);

    // Tap the 'Lihat Alarm' button and trigger a frame.
    await tester.tap(find.text('Lihat Alarm'));
    await tester.pumpAndSettle();

    // Verify that we navigated to the alarm list screen
    expect(find.text('Daftar Alarm'), findsOneWidget);
  });
}