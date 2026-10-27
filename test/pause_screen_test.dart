import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/features/pause/presentation/viewmodels/pause_viewmodel.dart';
import 'package:app/features/pause/presentation/views/pause_screen.dart';

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
        home: const PauseScreen(),
      ),
    );
  }

  testWidgets('PauseScreen renders all blueprint UI elements matching reference image',
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
    expect(find.text('Take a pause ðŸŒ¿'), findsOneWidget);
    expect(find.text('A little space just for you.'), findsOneWidget);
    expect(find.byIcon(Icons.eco_rounded), findsWidgets);

    // 2. Hero Mint Card
    expect(find.text('YOUR MOMENT OF CALM'), findsOneWidget);
    expect(find.text("Let's slow things down."), findsOneWidget);
    expect(find.text("You don't have to solve everything right now."), findsOneWidget);
    expect(find.text('Mindful breathing'), findsOneWidget);
    expect(find.text('1 minute â€¢ Gentle breathing'), findsOneWidget);
    expect(find.text('Start breathing exercise â†’'), findsOneWidget);

    // 3. Choose your pause Section
    expect(find.text('Choose your pause'), findsOneWidget);
    expect(find.text('Breathe'), findsOneWidget);
    expect(find.text('Slow, gentle breaths'), findsOneWidget);
    expect(find.text('Ground'), findsOneWidget);
    expect(find.text('Reconnect with now'), findsOneWidget);
    expect(find.text('Relax'), findsOneWidget);
    expect(find.text('Release some tension'), findsOneWidget);

    // 4. A gentle reminder Card
    expect(find.text('A gentle reminder'), findsOneWidget);
    expect(find.text("It's okay to take things one moment at a time."), findsOneWidget);
  });

  testWidgets('Tapping Start breathing exercise opens guided breathing session modal',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap button to launch modal
    await tester.tap(find.text('Start breathing exercise â†’'));
    await tester.pumpAndSettle();

    // Verify modal is open with ready screen
    expect(find.text('Mindful breathing'), findsWidgets);
    expect(find.text('Begin breathing'), findsOneWidget);

    // Tap Begin breathing to start active session
    await tester.tap(find.text('Begin breathing'));
    await tester.pump();

    // Verify active session widgets render properly
    expect(find.text('Breathe in...'), findsOneWidget);
    expect(find.text('4s'), findsOneWidget);
    expect(find.text('Cycle 1 of 4'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Pause'), findsOneWidget);

    // Verify positions: close button is at the top, text is below the visual
    final closePos = tester.getTopLeft(find.byIcon(Icons.close_rounded));
    final phasePos = tester.getTopLeft(find.text('Breathe in...'));
    final cyclePos = tester.getTopLeft(find.text('Cycle 1 of 4'));
    final resetPos = tester.getTopLeft(find.text('Reset'));

    // The phase text and cycle text are well below the top bar close button
    expect(phasePos.dy > closePos.dy + 100, isTrue);
    expect(cyclePos.dy > phasePos.dy, isTrue);
    expect(resetPos.dy > cyclePos.dy, isTrue);

    // Close modal cleanly
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
  });

  testWidgets('Tapping Ground card opens 5-4-3-2-1 grounding exercise sheet',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap Ground card
    await tester.tap(find.text('Ground'));
    await tester.pumpAndSettle();

    // Verify 5-4-3-2-1 sheet is open
    expect(find.text('5-4-3-2-1 Grounding'), findsOneWidget);
    expect(find.text('5 things you can see'), findsOneWidget);
    expect(find.text('Next step â†’'), findsOneWidget);
  });

  testWidgets('Tapping Relax card opens body relaxation sheet',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap Relax card
    await tester.tap(find.text('Relax'));
    await tester.pumpAndSettle();

    // Verify Quick Body Relaxation sheet is open
    expect(find.text('Quick Body Relaxation'), findsOneWidget);
    expect(find.text('Drop your shoulders'), findsOneWidget);
    expect(find.text('Next â†’'), findsOneWidget);
  });

  test('PauseViewModel manages breathing timer, phases, and controls accurately', () {
    final vm = PauseViewModel();
    expect(vm.isActive, isFalse);
    expect(vm.isPaused, isFalse);
    expect(vm.currentPhase, BreathPhase.inhale);

    // Start session
    vm.startBreathingSession();
    expect(vm.isActive, isTrue);
    expect(vm.isPaused, isFalse);
    expect(vm.currentPhase, BreathPhase.inhale);
    expect(vm.phaseSecondsRemaining, 4);

    // Pause session
    vm.pauseSession();
    expect(vm.isPaused, isTrue);

    // Resume session
    vm.resumeSession();
    expect(vm.isPaused, isFalse);

    // Reset session
    vm.resetSession();
    expect(vm.currentPhase, BreathPhase.inhale);
    expect(vm.phaseSecondsRemaining, 4);

    // Stop session
    vm.stopSession();
    expect(vm.isActive, isFalse);
    vm.dispose();
  });
}

