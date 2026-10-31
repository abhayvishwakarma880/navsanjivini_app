import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

/// Implementation of [StorageService] backed by [SharedPreferences].
class SharedPreferencesStorageService implements StorageService {
  final SharedPreferences _prefs;

  SharedPreferencesStorageService(this._prefs);

  static Future<SharedPreferencesStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesStorageService(prefs);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}
