import 'package:flutter/material.dart';
import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/theme/app_theme.dart';
import '../features/explore/presentation/views/explore_screen.dart';
import '../features/help/presentation/views/help_screen.dart';
import '../features/home/presentation/views/home_screen.dart';
import '../features/mood/presentation/views/mood_checkin_screen.dart';
import '../features/onboarding/presentation/views/eligibility_screen.dart';
import '../features/onboarding/presentation/views/welcome_screen.dart';
import '../features/pause/presentation/views/pause_screen.dart';
import '../features/privacy/presentation/views/privacy_screen.dart';
import '../features/profile/presentation/views/profile_screen.dart';
import '../features/settings/presentation/views/settings_screen.dart';
import '../features/talk/presentation/views/talk_screen.dart';
import 'router.dart';

/// Root Application Widget for Navsanjivini.
class NavsanjiviniApp extends StatelessWidget {
  const NavsanjiviniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.initial,
      routes: {
        AppRoutes.initial: (context) => WelcomeScreen(
              onContinue: () {
                Navigator.of(context).pushNamed(AppRoutes.eligibility);
              },
            ),
        AppRoutes.eligibility: (context) => EligibilityScreen(
              onContinue: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              },
            ),
        AppRoutes.home: (context) => HomeScreen(
              onNavigateToMood: () {
                Navigator.of(context).pushNamed(AppRoutes.moodCheckin);
              },
              onNavigateToTalk: () {
                Navigator.of(context).pushNamed(AppRoutes.talk);
              },
              onNavigateToPause: () {
                Navigator.of(context).pushNamed(AppRoutes.pause);
              },
              onNavigateToExplore: () {
                Navigator.of(context).pushNamed(AppRoutes.explore);
              },
              onNavigateToHelp: () {
                Navigator.of(context).pushNamed(AppRoutes.help);
              },
            ),
        AppRoutes.moodCheckin: (context) => MoodCheckinScreen(
              onSaved: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mood check-in saved.')),
                );
              },
            ),
        AppRoutes.talk: (context) => const TalkScreen(),
        AppRoutes.pause: (context) => const PauseScreen(),
        AppRoutes.explore: (context) => const ExploreScreen(),
        AppRoutes.help: (context) => const HelpScreen(),
        AppRoutes.profile: (context) => ProfileScreen(
              onNavigateToPrivacy: () {
                Navigator.of(context).pushNamed(AppRoutes.privacy);
              },
              onNavigateToSettings: () {
                Navigator.of(context).pushNamed(AppRoutes.settings);
              },
            ),
        AppRoutes.privacy: (context) => const PrivacyScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
      },
    );
  }
}
