import 'package:flutter/foundation.dart';
import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/storage/storage_service.dart';
import 'app_languages.dart';
import 'app_strings.dart';
import 'en_strings.dart';
import 'hi_strings.dart';
import 'hinglish_strings.dart';

/// Controller that manages the active application language,
/// notifies listeners when it changes, and persists the user preference.
class LanguageController extends ChangeNotifier {
  final StorageService _storageService;
  AppLanguage _currentLanguage = AppLanguage.english;

  LanguageController(this._storageService, [AppLanguage initialLanguage = AppLanguage.english])
      : _currentLanguage = initialLanguage;

  AppLanguage get currentLanguage => _currentLanguage;

  /// Returns strongly-typed localized strings according to active language.
  AppStrings get strings {
    return switch (_currentLanguage) {
      AppLanguage.english => EnStrings(),
      AppLanguage.hindi => HiStrings(),
      AppLanguage.hinglish => HinglishStrings(),
    };
  }

  /// Change language and persist preference to local storage.
  Future<void> setLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;
    _currentLanguage = language;
    notifyListeners();
    try {
      await _storageService.setString(AppConstants.keyUserLanguage, language.code);
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }

  /// Load persisted language from storage.
  Future<void> loadSavedLanguage() async {
    try {
      final code = await _storageService.getString(AppConstants.keyUserLanguage);
      if (code != null) {
        final loadedLanguage = AppLanguage.fromCode(code);
        if (loadedLanguage != _currentLanguage) {
          _currentLanguage = loadedLanguage;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading language preference: $e');
    }
  }
}
