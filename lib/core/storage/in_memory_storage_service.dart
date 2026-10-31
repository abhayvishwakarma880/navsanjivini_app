import 'storage_service.dart';

/// In-memory implementation of [StorageService] useful for testing and preview fallback.
class InMemoryStorageService implements StorageService {
  final Map<String, dynamic> _store = {};

  @override
  Future<void> clear() async => _store.clear();

  @override
  Future<bool?> getBool(String key) async => _store[key] as bool?;

  @override
  Future<int?> getInt(String key) async => _store[key] as int?;

  @override
  Future<String?> getString(String key) async => _store[key] as String?;

  @override
  Future<void> remove(String key) async => _store.remove(key);

  @override
  Future<void> setBool(String key, bool value) async => _store[key] = value;

  @override
  Future<void> setInt(String key, int value) async => _store[key] = value;

  @override
  Future<void> setString(String key, String value) async => _store[key] = value;
}
