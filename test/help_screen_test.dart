import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/user/views/help_screen.dart';

void main() {
  late InMemoryStorageService storage;
  late LanguageController languageController;

  setUp(() {
    storage = InMemoryStorageService();
    languageController = LanguageController(storage);
  });

  Widget buildTestableWidget() {
    return LanguageScope(
      controller: languageController,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const HelpScreen(),
      ),
    );
  }

  testWidgets('HelpScreen renders all blueprint UI elements matching reference image',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // 1. Header
    expect(find.text("You're not alone ðŸŒ¿"), findsOneWidget);
    expect(find.text('Support is available when you need it.'), findsOneWidget);
    expect(find.byIcon(Icons.volunteer_activism_rounded), findsOneWidget);

    // 2. Hero Mint Card
    expect(find.text('What kind of support do you need?'), findsOneWidget);
    expect(find.text('Choose the option that feels right for you.'), findsOneWidget);

    // 3. Explore Support Section
    expect(find.text('Explore support'), findsOneWidget);
    expect(find.text('Talk to someone'), findsOneWidget);
    expect(find.text('Find trusted support services and contact options.'), findsOneWidget);
    expect(find.text('Helpful resources'), findsOneWidget);
    expect(find.text('Explore wellbeing guides and practical information.'), findsOneWidget);
    expect(find.text('App FAQs'), findsOneWidget);
    expect(find.text('Learn about privacy, journal entries and app features.'), findsOneWidget);

    // 4. Urgent Help Card
    expect(find.text('Need urgent help?'), findsOneWidget);
    expect(
      find.text('If you or someone else is in immediate danger, contact local emergency services or a trusted person who can help.'),
      findsOneWidget,
    );
    expect(find.text('View urgent support options â†’'), findsOneWidget);
  });

  testWidgets('Tapping Talk to someone navigates to verified helplines directory',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap Talk to someone
    await tester.tap(find.text('Talk to someone'));
    await tester.pumpAndSettle();

    // Verify verified helplines directory
    expect(find.text('Tele-MANAS'), findsOneWidget);
    expect(find.text('KIRAN Helpline'), findsOneWidget);
    expect(find.text('Call 14416'), findsOneWidget);

    // Back to main
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
  });

  testWidgets('Tapping Helpful resources navigates to guides and detail reader',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap Helpful resources
    await tester.tap(find.text('Helpful resources'));
    await tester.pumpAndSettle();

    // Verify categories & articles
    expect(find.text('Stress & Calm'), findsWidgets);
    expect(find.text('Understanding the Stress Response in the Body'), findsOneWidget);

    // Tap article to open reader
    await tester.tap(find.text('Understanding the Stress Response in the Body'));
    await tester.pumpAndSettle();

    // Verify reader view
    expect(find.text('Key Takeaways'), findsOneWidget);
    expect(find.text('1. The Biology of Feeling Overwhelmed'), findsOneWidget);

    // Go back
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
  });

  testWidgets('Tapping App FAQs navigates to expandable accordion screen',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap App FAQs
    await tester.tap(find.text('App FAQs'));
    await tester.pumpAndSettle();

    // Verify FAQ items
    expect(find.text('Is my personal data and journal private?'), findsOneWidget);
    expect(find.text('How does the AI Talk companion work?'), findsOneWidget);

    // Expand first FAQ
    await tester.tap(find.text('Is my personal data and journal private?'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Your journal entries and mood check-ins are stored locally on your device storage.'),
      findsOneWidget,
    );

    // Back to main
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
  });

  testWidgets('Tapping View urgent support options opens UrgentHelpModal',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap View urgent support options
    await tester.tap(find.text('View urgent support options â†’'));
    await tester.pumpAndSettle();

    // Verify modal elements
    expect(find.text('Urgent Support & Crisis Lines'), findsOneWidget);
    expect(find.text('112'), findsOneWidget);
    expect(find.text('14416'), findsOneWidget);
    expect(find.text('1800-599-0019'), findsOneWidget);
    expect(find.text('Call 112'), findsOneWidget);

    // Close modal
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
  });
}

