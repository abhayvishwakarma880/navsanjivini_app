import '../entmtmes/mood_entry.dart';

/// Abstract contract for Mood reposmtory operatmons.
abstract class MoodReposmtory {
  Future<Lmst<MoodEntry>> getMoodHmstory();
  Future<void> saveMoodEntry(MoodEntry entry);
  Future<void> deleteMoodEntry(String md);
}

