import 'package:flutter/material.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:app/core/theme/app_theme.dart';
import '../features/auth/data/repositories/mock_auth_repository.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../features/auth/presentation/views/auth_screen.dart';
import '../features/explore/presentation/views/explore_screen.dart';
import '../features/help/presentation/views/help_screen.dart';
import '../features/home/presentation/views/main_shell_screen.dart';
import '../features/mood/presentation/views/mood_checkin_screen.dart';
import '../features/onboarding/presentation/views/eligibility_screen.dart';
import '../features/onboarding/presentation/views/language_selection_screen.dart';
import '../features/onboarding/presentation/views/welcome_screen.dart';
import '../features/pause/presentation/views/pause_screen.dart';
import '../features/privacy/presentation/views/privacy_screen.dart';
import '../features/profile/presentation/views/profile_screen.dart';
import '../features/settings/presentation/views/settings_screen.dart';
import '../features/talk/presentation/views/talk_screen.dart';
import 'router.dart';

/// Root Application Widget for Navsanjivini.
class NavsanjiviniApp extends StatefulWidget {
  final LanguageController? languageController;
  final StorageService? storageService;

  const NavsanjiviniApp({
    super.key,
    this.languageController,
    this.storageService,
  });

  @override
  State<NavsanjiviniApp> createState() => _NavsanjiviniAppState();
}

class _NavsanjiviniAppState extends State<NavsanjiviniApp> {
  late final StorageService _storageService;
  late final LanguageController _controller;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _storageService = widget.storageService ?? InMemoryStorageService();
    _controller = widget.languageController ?? LanguageController(_storageService);
    _authRepository = MockAuthRepository(_storageService);
  }

  @override
  Widget build(BuildContext context) {
    return LanguageScope(
      controller: _controller,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: context.tr.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.initial,
            routes: {
              AppRoutes.initial: (context) => WelcomeScreen(
                    onContinue: () {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
                    },
                  ),
              AppRoutes.language: (context) => LanguageSelectionScreen(
                    onContinue: () {
                      Navigator.of(context).pushNamed(AppRoutes.eligibility);
                    },
                  ),
              AppRoutes.eligibility: (context) => EligibilityScreen(
                    onContinue: () {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
                    },
                  ),
              AppRoutes.auth: (context) => AuthScreen(
                    viewModel: AuthViewModel(_authRepository),
                    onAuthSuccess: () {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                    },
                  ),
              AppRoutes.home: (context) => MainShellScreen(
                    onLogout: () async {
                      await _authRepository.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.auth,
                          (route) => false,
                        );
                      }
                    },
                    onNavigateToSettings: () {
                      Navigator.of(context).pushNamed(AppRoutes.settings);
                    },
                    onNavigateToPrivacy: () {
                      Navigator.of(context).pushNamed(AppRoutes.privacy);
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
                    onLogout: () async {
                      await _authRepository.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.auth,
                          (route) => false,
                        );
                      }
                    },
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
        },
      ),
    );
  }
}
