/// Supported languages for Navsanjivini.
enum AppLanguage {
  english(code: 'en', displayName: 'English', nativeName: 'English'),
  hindi(code: 'hi', displayName: 'Hindi', nativeName: 'हिंदी'),
  hinglish(code: 'hi_en', displayName: 'Hinglish', nativeName: 'Hinglish');

  final String code;
  final String displayName;
  final String nativeName;

  const AppLanguage({
    required this.code,
    required this.displayName,
    required this.nativeName,
  });

  /// Parse language from stored string code or default to English.
  static AppLanguage fromCode(String? code) {
    if (code == null) return AppLanguage.english;
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
