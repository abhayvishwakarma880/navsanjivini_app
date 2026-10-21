import 'package:flutter/foundation.dart';

class ProfileViewModel extends ChangeNotifier {
  String _displayName = 'Abhay';
  String _language = 'English / Hinglish';

  String get displayName => _displayName;
  String get language => _language;

  void updateName(String name) {
    _displayName = name;
    notifyListeners();
  }
}
