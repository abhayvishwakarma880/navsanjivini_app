import 'package:flutter/foundation.dart';
import 'package:app/core/utils/date_time_utils.dart';

class HomeViewModel extends ChangeNotifier {
  String _userName = 'Friend';
  String _dailyThought = 'Take a deep breath. You do not have to figure everything out today.';
  bool _hasCheckedInToday = false;

  String get userName => _userName;
  String get greeting => '${DateTimeUtils.getGreeting()}, $_userName';
  String get dailyThought => _dailyThought;
  bool get hasCheckedInToday => _hasCheckedInToday;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void markCheckedIn() {
    _hasCheckedInToday = true;
    notifyListeners();
  }

  void updateDailyThought(String thought) {
    _dailyThought = thought;
    notifyListeners();
  }
}

