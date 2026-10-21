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

    // Default starts on WelcomeScreen -> Tap Get Started to go to Language Selection
    expect(find.text('Get Started'), findsOneWidget);
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Choose your language'), findsOneWidget);

    // Tap Hindi option
    await tester.tap(find.text('हिंदी'));
    await tester.pumpAndSettle();

    // UI should reactively update to Hindi immediately!
    expect(find.text('आगे बढ़ें'), findsOneWidget);
    expect(find.text('अपनी भाषा चुनें'), findsOneWidget);

    // Tap Hinglish option
    await tester.tap(find.text('Hinglish').first);
    await tester.pumpAndSettle();

    // UI should reactively update to Hinglish immediately!
    expect(find.text('Aage Badhein'), findsOneWidget);
    expect(find.text('Apni language choose karein'), findsOneWidget);
  });
}
