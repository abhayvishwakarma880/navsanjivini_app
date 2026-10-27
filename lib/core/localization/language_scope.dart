import 'package:flutter/widgets.dart';
import 'app_languages.dart';
import 'app_strings.dart';
import 'language_controller.dart';

/// Provides [LanguageController] down the widget tree using Flutter's built-in [InheritedNotifier].
/// Whenever [LanguageController.notifyListeners] is called, dependent widgets rebuild automatically.
class LanguageScope extends InheritedNotifier<LanguageController> {
  const LanguageScope({
    super.key,
    required LanguageController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Access the active [LanguageController] from [context].
  static LanguageController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LanguageScope>();
    assert(scope != null, 'No LanguageScope found in context. Ensure LanguageScope wraps your widget tree.');
    return scope!.notifier!;
  }
}

/// Syntactic sugar on [BuildContext] to access strings and change language easily.
extension LocalizationExtension on BuildContext {
  /// Access strongly-typed localized strings: `context.tr.appName`
  AppStrings get tr => LanguageScope.of(this).strings;

  /// Get current language: `context.currentLanguage`
  AppLanguage get currentLanguage => LanguageScope.of(this).currentLanguage;

  /// Update language: `context.setLanguage(AppLanguage.hindi)`
  void setLanguage(AppLanguage language) {
    LanguageScope.of(this).setLanguage(language);
  }
}

