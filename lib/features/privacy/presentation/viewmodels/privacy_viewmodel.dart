import 'package:flutter/foundation.dart';

class PrivacyViewModel extends ChangeNotifier {
  bool _aiDataRetentionConsent = false;
  bool _isRequestingDeletion = false;

  bool get aiDataRetentionConsent => _aiDataRetentionConsent;
  bool get isRequestingDeletion => _isRequestingDeletion;

  void toggleAiDataRetention(bool value) {
    _aiDataRetentionConsent = value;
    notifyListeners();
  }

  Future<void> requestAccountDeletion() async {
    _isRequestingDeletion = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _isRequestingDeletion = false;
    notifyListeners();
  }
}
