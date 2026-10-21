import 'package:flutter/material.dart';

/// App navigation route names.
abstract final class AppRoutes {
  static const String initial = '/';
  static const String onboarding = '/onboarding';
  static const String language = '/onboarding/language';
  static const String eligibility = '/onboarding/eligibility';
  static const String home = '/home';
  static const String moodCheckin = '/mood/checkin';
  static const String moodHistory = '/mood/history';
  static const String talk = '/talk';
  static const String pause = '/pause';
  static const String explore = '/explore';
  static const String journal = '/journal';
  static const String help = '/help';
  static const String progress = '/progress';
  static const String profile = '/profile';
  static const String privacy = '/privacy';
  static const String settings = '/settings';
}

/// AppRouter provides centralized navigation configuration.
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
