/// Centralized API endpoint paths.
/// Decoupled from backend implementation so contracts remain clean.
abstract final class ApiEndpoints {
  static const String baseUrl = 'https://api.navsanjivini.com/v1';

  // Auth & Onboarding
  static const String register = '/auth/register';
  static const String consent = '/user/consent';

  // Mood
  static const String moodCheckin = '/mood/checkin';
  static const String moodHistory = '/mood/history';

  // AI Talk
  static const String talkSession = '/talk/session';
  static const String talkMessage = '/talk/message';

  // Explore & Help
  static const String exploreGuides = '/explore/guides';
  static const String emergencyResources = '/help/resources';

  // User & Privacy
  static const String userProfile = '/user/profile';
  static const String deleteAccount = '/user/delete-account';
  static const String exportData = '/user/export-data';
}
