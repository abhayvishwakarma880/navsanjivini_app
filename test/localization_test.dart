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
    expect(controller.strings.continueBtn, 'आगे बढ़ें');

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
    await tester.tap(find.text('हिंदी'));
    await tester.pumpAndSettle();

    // UI should reactively update to Hindi immediately!
    expect(find.text('अपनी भाषा चुनें'), findsOneWidget);
    expect(find.text('शुरू करें'), findsOneWidget);
    expect(find.text('सुरक्षा एवं सहमति'), findsOneWidget);

    // Tap Hinglish option directly on WelcomeScreen
    await tester.tap(find.text('Hinglish').first);
    await tester.pumpAndSettle();

    // UI should reactively update to Hinglish immediately!
    expect(find.text('Apni language choose karein'), findsOneWidget);
    expect(find.text('Safety aur Consent'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
