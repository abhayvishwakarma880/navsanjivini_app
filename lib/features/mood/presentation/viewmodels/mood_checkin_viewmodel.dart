import 'package:flutter/foundation.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/repositories/mood_repository.dart';

class MoodCheckinViewModel extends ChangeNotifier {
  final MoodRepository? repository;

  MoodCheckinViewModel({this.repository});

  MoodType? _selectedMood;
  int _intensity = 3; // 1 to 5
  String _note = '';
  final List<String> _selectedTags = [];
  bool _isSaving = false;
  String? _errorMessage;

  MoodType? get selectedMood => _selectedMood;
  int get intensity => _intensity;
  String get note => _note;
  List<String> get selectedTags => List.unmodifiable(_selectedTags);
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  bool get canSave => _selectedMood != null && !_isSaving;

  void selectMood(MoodType mood) {
    _selectedMood = mood;
    _errorMessage = null;
    notifyListeners();
  }

  void setIntensity(int value) {
    if (value >= 1 && value <= 5) {
      _intensity = value;
      notifyListeners();
    }
  }

  void setNote(String note) {
    _note = note;
    notifyListeners();
  }

  void toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    notifyListeners();
  }

  Future<bool> saveCheckin() async {
    if (_selectedMood == null) return false;

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final entry = MoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        mood: _selectedMood!,
        intensity: _intensity,
        note: _note.trim().isEmpty ? null : _note.trim(),
        tags: _selectedTags,
        timestamp: DateTime.now(),
      );

      if (repository != null) {
        await repository!.saveMoodEntry(entry);
      }

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = 'Unable to save mood check-in. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _selectedMood = null;
    _intensity = 3;
    _note = '';
    _selectedTags.clear();
    _isSaving = false;
    _errorMessage = null;
    notifyListeners();
  }
}
