import '../entities/mood_entry.dart';

/// Abstract contract for Mood repository operations.
abstract class MoodRepository {
  Future<List<MoodEntry>> getMoodHistory();
  Future<void> saveMoodEntry(MoodEntry entry);
  Future<void> deleteMoodEntry(String id);
}
