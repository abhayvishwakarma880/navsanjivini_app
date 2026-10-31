import 'package:flutter/material.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:app/core/theme/app_theme.dart';

// Common module (shared by User & Doctor)
import '../common/features/onboarding/presentation/views/eligibility_screen.dart';
import '../common/features/onboarding/presentation/views/language_selection_screen.dart';
import '../common/features/onboarding/presentation/views/welcome_screen.dart';

// Doctor module
import '../doctor/features/auth/data/repositories/mock_doctor_auth_repository.dart';
import '../doctor/features/auth/domain/repositories/doctor_auth_repository.dart';
import '../doctor/features/auth/presentation/viewmodels/doctor_auth_viewmodel.dart';
import '../doctor/features/auth/presentation/views/doctor_login_screen.dart';

// User module
import '../user/features/auth/data/repositories/mock_auth_repository.dart';
import '../user/features/auth/domain/repositories/auth_repository.dart';
import '../user/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../user/features/auth/presentation/views/auth_screen.dart';

import '../user/features/explore/presentation/views/explore_screen.dart';
import '../user/features/help/presentation/views/help_screen.dart';
import '../user/features/home/presentation/views/main_shell_screen.dart';
import '../user/features/mood/presentation/views/mood_checkin_screen.dart';
import '../user/features/pause/presentation/views/pause_screen.dart';
import '../user/features/privacy/presentation/views/privacy_screen.dart';
import '../user/features/profile/presentation/views/profile_screen.dart';
import '../user/features/settings/presentation/views/settings_screen.dart';
import '../user/features/talk/presentation/views/talk_screen.dart';

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
  late final DoctorAuthRepository _doctorAuthRepository;

  @override
  void initState() {
    super.initState();
    _storageService = widget.storageService ?? InMemoryStorageService();
    _controller = widget.languageController ?? LanguageController(_storageService);
    _authRepository = MockAuthRepository(_storageService);
    _doctorAuthRepository = MockDoctorAuthRepository(_storageService);
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
              // Common Flow: Welcome -> Language -> Eligibility -> Auth
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

              // User Authentication (User Login & Register)
              AppRoutes.auth: (context) => AuthScreen(
                    viewModel: AuthViewModel(_authRepository),
                    onAuthSuccess: () {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                    },
                    onNavigateToDoctorLogin: () {
                      Navigator.of(context).pushNamed(AppRoutes.doctorLogin);
                    },
                  ),

              // Doctor Authentication (Email + Password only)
              AppRoutes.doctorLogin: (context) => DoctorLoginScreen(
                    viewModel: DoctorAuthViewModel(_doctorAuthRepository),
                    onAuthSuccess: () {
                      // Doctor login opens the same main screen as user login
                      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                    },
                    onNavigateToUserLogin: () {
                      Navigator.of(context).pop();
                    },
                  ),

              // Main Application Shell (Home, Mood, Talk, Pause, Journal, Help)
              AppRoutes.home: (context) => MainShellScreen(
                    onLogout: () async {
                      await _authRepository.logout();
                      await _doctorAuthRepository.logout();
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
                      await _doctorAuthRepository.logout();
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

