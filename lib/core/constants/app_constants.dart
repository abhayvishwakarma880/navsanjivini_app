/// Global app constants for Navsanjivini.
abstract final class AppConstants {
  static const String appName = 'Navsanjivini';
  static const String appTagline = 'Your safe space for emotional well-being';
  static const String appVersion = '1.0.0';

  // Eligibility
  static const int minimumAge = 18;

  // Disclaimer
  static const String clinicalDisclaimer =
      'Navsanjivini is an emotional well-being and self-help support tool. '
      'It is not a substitute for professional clinical diagnosis or psychiatric treatment.';

  // Storage Keys
  static const String keyUserLanguage = 'user_language';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyAgeConfirmed = 'age_confirmed_18_plus';
  static const String keyConsentGiven = 'consent_given';
  static const String keyAuthToken = 'auth_token';
}
