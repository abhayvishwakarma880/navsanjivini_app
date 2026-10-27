import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/user/views/home_screen.dart';
import 'package:app/user/views/main_shell_screen.dart';
import 'package:app/user/views/profile_screen.dart';

void main() {
  late InMemoryStorageService storage;
  late LanguageController languageController;

  setUp(() {
    storage = InMemoryStorageService();
    languageController = LanguageController(storage);
  });

  Widget buildTestableWidget(Widget child) {
    return LanguageScope(
      controller: languageController,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: child,
      ),
    );
  }

  group('MainShellScreen 5-Item Navigation Tests', () {
    testWidgets('Renders all 5 persistent tabs (Today, Talk, Pause, Journal, Help)',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          MainShellScreen(
            onLogout: () {},
            onNavigateToSettings: () {},
            onNavigateToPrivacy: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify bottom navigation labels exist
      expect(find.text('Today'), findsWidgets);
      expect(find.text('Talk'), findsWidgets);
      expect(find.text('Pause'), findsWidgets);
      expect(find.text('Journal'), findsWidgets);
      expect(find.text('Help'), findsWidgets);

      // Verify IndexedStack exists
      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets('Tapping bottom tabs switches views smoothly without resetting state',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          MainShellScreen(
            onLogout: () {},
            onNavigateToSettings: () {},
            onNavigateToPrivacy: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Starts on Today (HomeScreen is child index 0)
      expect(find.text('How are you feeling today?'), findsOneWidget);

      // Tap on Talk tab
      await tester.tap(find.text('Talk'));
      await tester.pumpAndSettle();

      final indexedStack = tester.widget<IndexedStack>(find.byType(IndexedStack));
      expect(indexedStack.index, 1);

      // Tap on Pause tab
      await tester.tap(find.text('Pause'));
      await tester.pumpAndSettle();
      final indexedStackPause = tester.widget<IndexedStack>(find.byType(IndexedStack));
      expect(indexedStackPause.index, 2);

      // Tap on Journal tab
      await tester.tap(find.text('Journal'));
      await tester.pumpAndSettle();
      final indexedStackJournal = tester.widget<IndexedStack>(find.byType(IndexedStack));
      expect(indexedStackJournal.index, 3);

      // Tap on Help tab
      await tester.tap(find.text('Help'));
      await tester.pumpAndSettle();
      final indexedStackHelp = tester.widget<IndexedStack>(find.byType(IndexedStack));
      expect(indexedStackHelp.index, 4);

      // Tap back to Today tab
      await tester.tap(find.text('Today'));
      await tester.pumpAndSettle();
      final indexedStackToday = tester.widget<IndexedStack>(find.byType(IndexedStack));
      expect(indexedStackToday.index, 0);
    });
  });

  group('HomeScreen Blueprint Layout Tests', () {
    testWidgets('Renders all blueprint elements accurately', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      bool moodTapped = false;
      bool profileTapped = false;
      bool talkTapped = false;
      bool journalTapped = false;

      await tester.pumpWidget(
        buildTestableWidget(
          HomeScreen(
            onNavigateToMood: () => moodTapped = true,
            onNavigateToTalk: () => talkTapped = true,
            onNavigateToPause: () {},
            onNavigateToExplore: () {},
            onNavigateToJournal: () => journalTapped = true,
            onNavigateToHelp: () {},
            onNavigateToProfile: () => profileTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Top Greeting & Subtitle
      expect(find.text('How are you feeling today?'), findsOneWidget);
      expect(find.textContaining('ðŸŒ¿'), findsWidgets);

      // Mood Check-in Card (5 Moods)
      expect(find.text('A moment for yourself'), findsOneWidget);
      expect(find.text('How are you feeling right now?'), findsOneWidget);
      expect(find.text('Great'), findsOneWidget);
      expect(find.text('Okay'), findsOneWidget);
      expect(find.text('Low'), findsOneWidget);
      expect(find.text('Anxious'), findsOneWidget);
      expect(find.text('Overwhelmed'), findsOneWidget);
      expect(find.text('Check in with your mood â†’'), findsOneWidget);

      // Select 'Great' mood -> shows supportive response
      await tester.tap(find.text('Great'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Wonderful to hear'), findsOneWidget);

      // Take a small pause card
      expect(find.text('Take a small pause'), findsOneWidget);
      expect(find.text('A minute to breathe and reset.'), findsOneWidget);

      // "What would help right now?" section (4 cards)
      expect(find.text('What would help right now?'), findsOneWidget);
      expect(find.text('Talk it out'), findsOneWidget);
      expect(find.text("Share what's on your mind"), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('My Journal'), findsOneWidget);
      expect(find.text('Write privately'), findsOneWidget);
      expect(find.text('Find support'), findsOneWidget);

      // A gentle thought
      expect(find.text('A gentle thought ðŸŒ±'), findsOneWidget);
      expect(find.text('Small steps count, even on difficult days.'), findsOneWidget);

      // Test Mood Checkin tap
      await tester.tap(find.text('Check in with your mood â†’'));
      expect(moodTapped, isTrue);

      // Test Profile icon tap
      await tester.tap(find.byIcon(Icons.person_outline_rounded).first);
      expect(profileTapped, isTrue);

      // Test Talk it out card tap
      await tester.tap(find.text('Talk it out'));
      expect(talkTapped, isTrue);

      // Test My Journal card tap
      await tester.tap(find.text('My Journal'));
      expect(journalTapped, isTrue);
    });
  });

  group('Profile Screen Blueprint Tests', () {
    testWidgets('Displays all account, preferences, privacy, and logout items',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      bool logoutCalled = false;

      await tester.pumpWidget(
        buildTestableWidget(
          ProfileScreen(
            onLogout: () => logoutCalled = true,
            onNavigateToPrivacy: () {},
            onNavigateToSettings: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Profile header & items
      expect(find.text('Your profile'), findsOneWidget);
      expect(find.text('Personal information'), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Privacy & consent'), findsOneWidget);
      expect(find.text('Download my data'), findsOneWidget);
      expect(find.text('Delete account'), findsOneWidget);
      expect(find.text('Help & about'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);

      // Tapping Log out opens confirmation dialog
      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to sign out from this device?'), findsOneWidget);

      // Confirm Logout inside dialog
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log out'));
      await tester.pumpAndSettle();

      expect(logoutCalled, isTrue);
    });
  });
}

