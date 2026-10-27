import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/localization/app_languages.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/app/app.dart';

void main() {
  test('LanguageController updates strings correctly for all 3 languages', () async {
    final storage = InMemoryStorageService();
    final controller = LanguageController(storage);

    expect(controller.currentLanguage, AppLanguage.english);
    expect(controller.strings.continueBtn, 'Continue');

    // Switch to Hindi
    await controller.setLanguage(AppLanguage.hindi);
    expect(controller.currentLanguage, AppLanguage.hindi);
    expect(controller.strings.continueBtn, 'à¤†à¤—à¥‡ à¤¬à¤¢à¤¼à¥‡à¤‚');

    // Switch to Hinglish
    await controller.setLanguage(AppLanguage.hinglish);
    expect(controller.currentLanguage, AppLanguage.hinglish);
    expect(controller.strings.continueBtn, 'Aage Badhein');
  });

  testWidgets('Selecting Hindi and Hinglish on WelcomeScreen translates the UI instantly', (tester) async {
    final storage = InMemoryStorageService();
    final controller = LanguageController(storage);

    await tester.pumpWidget(NavsanjiviniApp(languageController: controller));
    await tester.pumpAndSettle();

    // WelcomeScreen renders Language Selection and Safety consent directly on screen
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('Safety & Consent'), findsOneWidget);

    // Tap Hindi option directly on WelcomeScreen
    await tester.tap(find.text('à¤¹à¤¿à¤‚à¤¦à¥€'));
    await tester.pumpAndSettle();

    // UI should reactively update to Hindi immediately!
    expect(find.text('à¤…à¤ªà¤¨à¥€ à¤­à¤¾à¤·à¤¾ à¤šà¥à¤¨à¥‡à¤‚'), findsOneWidget);
    expect(find.text('à¤¶à¥à¤°à¥‚ à¤•à¤°à¥‡à¤‚'), findsOneWidget);
    expect(find.text('à¤¸à¥à¤°à¤•à¥à¤·à¤¾ à¤à¤µà¤‚ à¤¸à¤¹à¤®à¤¤à¤¿'), findsOneWidget);

    // Tap Hinglish option directly on WelcomeScreen
    await tester.tap(find.text('Hinglish').first);
    await tester.pumpAndSettle();

    // UI should reactively update to Hinglish immediately!
    expect(find.text('Apni language choose karein'), findsOneWidget);
    expect(find.text('Safety aur Consent'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}

