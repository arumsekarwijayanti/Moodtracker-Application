import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mood_tracker_app/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> waitForElement(WidgetTester tester, Finder finder,
      {Duration timeout = const Duration(seconds: 5)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump();
      if (finder.evaluate().isNotEmpty) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    throw Exception('Timeout waiting for element $finder');
  }

  tearDownAll(() async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('[TEST] Semua pengujian selesai ✅');
  });

  group('Versi 1 - Tanpa Mood Journal dan Mood Details', () {
    setUp(() {
      app.isFeatureMoodJournalEnabled = false;
    });

    testWidgets('Test Versi 1', (WidgetTester tester) async {
      debugPrint('[TEST] Mulai pengujian Versi 1...');
      app.main(); // TANPA testMode
      await tester.pumpAndSettle();

      // Tunggu animasi selesai
      await tester.pump(const Duration(seconds: 2));

      await waitForElement(tester, find.byKey(const Key('button_add_mood')));
      await tester.tap(find.byKey(const Key('button_add_mood')));
      await tester.pumpAndSettle();

      await waitForElement(tester, find.byKey(const Key('mood_happy')));
      await tester.tap(find.byKey(const Key('mood_happy')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('edit_text_journal')), findsNothing);

      await waitForElement(tester, find.byKey(const Key('button_save_mood')));
      await tester.tap(find.byKey(const Key('button_save_mood')));
      await tester.pumpAndSettle();

      expect(find.text('Happy'), findsOneWidget);
      await tester.tap(find.text('Happy'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('mood_detail_page')), findsNothing);
      expect(find.byKey(const Key('button_mood_journal')), findsNothing);

      debugPrint('[TEST] Versi 1 selesai.');
    });
  });

  group('Versi 2 - Dengan Mood Journal dan Mood Details', () {
    setUp(() {
      app.isFeatureMoodJournalEnabled = true;
    });

    testWidgets('Test Versi 2', (WidgetTester tester) async {
      debugPrint('[TEST] Mulai pengujian Versi 2...');
      app.main(); // TANPA testMode
      await tester.pumpAndSettle();

      // Tunggu animasi selesai
      await tester.pump(const Duration(seconds: 2));

      await waitForElement(tester, find.byKey(const Key('button_add_mood')));
      await tester.tap(find.byKey(const Key('button_add_mood')));
      await tester.pumpAndSettle();

      await waitForElement(tester, find.byKey(const Key('mood_happy')));
      await tester.tap(find.byKey(const Key('mood_happy')));
      await tester.pumpAndSettle();

      await waitForElement(tester, find.byKey(const Key('edit_text_journal')));
      await tester.enterText(find.byKey(const Key('edit_text_journal')), 'Feeling really good today');
      await tester.pumpAndSettle();

      await waitForElement(tester, find.byKey(const Key('button_save_mood')));
      await tester.tap(find.byKey(const Key('button_save_mood')));
      await tester.pumpAndSettle();

      expect(find.text('Happy'), findsOneWidget);
      expect(find.text('Feeling really good today'), findsOneWidget);

      await tester.tap(find.text('Happy'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('mood_detail_page')), findsOneWidget);
      expect(find.text('Feeling really good today'), findsOneWidget);

      expect(find.byKey(const Key('button_mood_journal')), findsOneWidget);

      debugPrint('[TEST] Versi 2 selesai.');
    });
  });
}
