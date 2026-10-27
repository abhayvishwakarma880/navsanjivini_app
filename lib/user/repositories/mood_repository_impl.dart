import '../models/mood_entry.dart';
import 'mood_repository.dart';
import 'mood_local_datasource.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodLocalDataSource localDataSource;

  MoodRepositoryImpl({required this.localDataSource});

  @override
  Future<List<MoodEntry>> getMoodHistory() async {
    return localDataSource.getCachedMoodEntries();
  }

  @override
  Future<void> saveMoodEntry(MoodEntry entry) async {
    await localDataSource.cacheMoodEntry(entry);
  }

  @override
  Future<void> deleteMoodEntry(String id) async {
    await localDataSource.removeMoodEntry(id);
  }
}

