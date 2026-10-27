import 'package:flutter/foundation.dart';
import 'package:app/core/localization/app_languages.dart';

/// ViewModel managing Onboarding, Language Selection, and Age/Consent checks.
class OnboardingViewModel extends ChangeNotifier {
  AppLanguage _selectedLanguage = AppLanguage.english;
  bool _is18PlusConfirmed = false;
  bool _isConsentAccepted = false;
  bool _isLoading = false;

  AppLanguage get selectedLanguage => _selectedLanguage;
  bool get is18PlusConfirmed => _is18PlusConfirmed;
  bool get isConsentAccepted => _isConsentAccepted;
  bool get isLoading => _isLoading;
  bool get canProceed => _is18PlusConfirmed && _isConsentAccepted;

  void selectLanguage(AppLanguage language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void toggleAgeConfirmation(bool value) {
    _is18PlusConfirmed = value;
    notifyListeners();
  }

  void toggleConsent(bool value) {
    _isConsentAccepted = value;
    notifyListeners();
  }

  Future<bool> completeOnboarding() async {
    _isLoading = true;
    notifyListeners();

    // Persist onboarding status via storage repository
    await Future.delayed(const Duration(milliseconds: 300));

    _isLoading = false;
    notifyListeners();
    return true;
  }
}

