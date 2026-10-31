import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/user/features/talk/presentation/views/talk_screen.dart';

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
        home: const TalkScreen(),
      ),
    );
  }

  testWidgets('TalkScreen renders header, initial messages, and suggested prompts',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Verify header elements
    expect(find.text('Talk it out'), findsOneWidget);
    expect(find.byIcon(Icons.eco_rounded), findsOneWidget);
    expect(find.text("A safe space to share what's on your mind."), findsOneWidget);

    // Verify top eyebrow banner
    expect(find.text('YOUR PERSONAL WELL-BEING SPACE'), findsOneWidget);
    expect(find.text('You can start wherever you are.'), findsOneWidget);
    expect(find.text('No pressure to find the perfect words.'), findsOneWidget);

    // Verify initial chat conversation matching image
    expect(find.text("Hi there 🌿 I'm here to listen. What's been on your mind today?"), findsOneWidget);
    expect(find.text("I've been feeling a little overwhelmed lately."), findsOneWidget);
    expect(find.text("That sounds like a lot to carry. Would you like to talk about what's been feeling overwhelming?"), findsOneWidget);

    // Verify suggested prompt chips
    expect(find.text('You can also start with:'), findsOneWidget);
    expect(find.text('Work or studies'), findsOneWidget);
    expect(find.text('My feelings'), findsOneWidget);
    expect(find.text('I just need to vent'), findsOneWidget);

    // Verify input bar and disclaimer
    expect(find.text("Type what's on your mind..."), findsOneWidget);
    expect(find.text('A supportive space, not a substitute for professional care.'), findsOneWidget);
    expect(find.byIcon(Icons.send_rounded), findsOneWidget);
  });

  testWidgets('Tapping suggested prompt chip sends message and generates supportive dummy response',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap 'Work or studies' chip
    await tester.tap(find.text('Work or studies'));
    await tester.pump(); // starts message send

    expect(find.text('Work or studies'), findsWidgets);

    // Advance time for dummy response delay
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    // Verify companion's tailored response
    expect(find.textContaining('Work and study demands can build up quietly'), findsOneWidget);
  });

  testWidgets('Typing custom message and sending produces thoughtful empathetic response',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Enter text into field
    await tester.enterText(find.byType(TextField), 'I am feeling anxious about tomorrow');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    expect(find.text('I am feeling anxious about tomorrow'), findsOneWidget);

    // Wait for companion dummy reply
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.textContaining('When anxiety shows up'), findsOneWidget);
  });
}
