import 'package:flutter/foundation.dart';

class ProgressViewModel extends ChangeNotifier {
  final int _checkinsThisWeek = 5;
  final int _pauseMinutes = 24;
  final int _journalEntriesCount = 3;

  int get checkinsThisWeek => _checkinsThisWeek;
  int get pauseMinutes => _pauseMinutes;
  int get journalEntriesCount => _journalEntriesCount;
}

