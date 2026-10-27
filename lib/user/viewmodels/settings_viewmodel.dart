import 'package:flutter/foundation.dart';

class SettingsViewModel extends ChangeNotifier {
  bool _dailyReminders = true;
  bool _quietHoursEnabled = true;
  bool _hapticFeedback = true;
  bool _highContrast = false;

  bool get dailyReminders => _dailyReminders;
  bool get quietHoursEnabled => _quietHoursEnabled;
  bool get hapticFeedback => _hapticFeedback;
  bool get highContrast => _highContrast;

  void toggleDailyReminders(bool val) {
    _dailyReminders = val;
    notifyListeners();
  }

  void toggleQuietHours(bool val) {
    _quietHoursEnabled = val;
    notifyListeners();
  }

  void toggleHapticFeedback(bool val) {
    _hapticFeedback = val;
    notifyListeners();
  }

  void toggleHighContrast(bool val) {
    _highContrast = val;
    notifyListeners();
  }
}

