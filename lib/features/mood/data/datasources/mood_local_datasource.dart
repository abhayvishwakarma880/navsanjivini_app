import 'package:app/core/storage/storage_service.dart';
import '../../domain/entities/mood_entry.dart';

/// Local data source contract for caching mood check-in records.
abstract class MoodLocalDataSource {
  Future<List<MoodEntry>> getCachedMoodEntries();
  Future<void> cacheMoodEntry(MoodEntry entry);
  Future<void> removeMoodEntry(String id);
}

class MoodLocalDataSourceImpl implements MoodLocalDataSource {
  final StorageService storageService;

  MoodLocalDataSourceImpl({required this.storageService});

  final List<MoodEntry> _inMemoryCache = [];

  @override
  Future<List<MoodEntry>> getCachedMoodEntries() async {
    return List.unmodifiable(_inMemoryCache);
  }

  @override
  Future<void> cacheMoodEntry(MoodEntry entry) async {
    _inMemoryCache.insert(0, entry);
  }

  @override
  Future<void> removeMoodEntry(String id) async {
    _inMemoryCache.removeWhere((item) => item.id == id);
  }
}

