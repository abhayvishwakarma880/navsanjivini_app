import 'package:flutter/foundation.dart';

enum ExerciseType { boxBreathing, breathing478, grounding54321 }

enum BreathPhase { inhale, hold, exhale, rest }

class PauseViewModel extends ChangeNotifier {
  ExerciseType _selectedExercise = ExerciseType.boxBreathing;
  BreathPhase _currentPhase = BreathPhase.inhale;
  bool _isActive = false;

  ExerciseType get selectedExercise => _selectedExercise;
  BreathPhase get currentPhase => _currentPhase;
  bool get isActive => _isActive;

  void selectExercise(ExerciseType exercise) {
    _selectedExercise = exercise;
    notifyListeners();
  }

  void toggleActive() {
    _isActive = !_isActive;
    notifyListeners();
  }

  void updatePhase(BreathPhase phase) {
    _currentPhase = phase;
    notifyListeners();
  }
}
