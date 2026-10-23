import 'dart:async';
import 'package:flutter/foundation.dart';

enum ExerciseType {
  breathing,
  grounding,
  relax,
}

enum BreathPhase {
  inhale(durationSeconds: 4),
  hold(durationSeconds: 4),
  exhale(durationSeconds: 4),
  rest(durationSeconds: 3);

  final int durationSeconds;
  const BreathPhase({required this.durationSeconds});
}

class PauseViewModel extends ChangeNotifier {
  ExerciseType _selectedExercise = ExerciseType.breathing;
  BreathPhase _currentPhase = BreathPhase.inhale;
  bool _isActive = false;
  bool _isPaused = false;
  int _phaseSecondsRemaining = 4;
  int _elapsedSeconds = 0;
  final int _totalSessionSeconds = 60; // 1 minute mindful pause
  int _currentCycle = 1;
  final int _totalCycles = 4;
  Timer? _timer;

  ExerciseType get selectedExercise => _selectedExercise;
  BreathPhase get currentPhase => _currentPhase;
  bool get isActive => _isActive;
  bool get isPaused => _isPaused;
  int get phaseSecondsRemaining => _phaseSecondsRemaining;
  int get elapsedSeconds => _elapsedSeconds;
  int get totalSessionSeconds => _totalSessionSeconds;
  int get currentCycle => _currentCycle;
  int get totalCycles => _totalCycles;
  bool get isSessionCompleted => _elapsedSeconds >= _totalSessionSeconds;

  void selectExercise(ExerciseType exercise) {
    _selectedExercise = exercise;
    notifyListeners();
  }

  void startBreathingSession() {
    _isActive = true;
    _isPaused = false;
    _currentPhase = BreathPhase.inhale;
    _phaseSecondsRemaining = BreathPhase.inhale.durationSeconds;
    _elapsedSeconds = 0;
    _currentCycle = 1;
    _startTimer();
    notifyListeners();
  }

  void pauseSession() {
    if (!_isActive || _isPaused) return;
    _isPaused = true;
    _timer?.cancel();
    notifyListeners();
  }

  void resumeSession() {
    if (!_isActive || !_isPaused) return;
    _isPaused = false;
    _startTimer();
    notifyListeners();
  }

  void resetSession() {
    _timer?.cancel();
    _currentPhase = BreathPhase.inhale;
    _phaseSecondsRemaining = BreathPhase.inhale.durationSeconds;
    _elapsedSeconds = 0;
    _currentCycle = 1;
    _isPaused = false;
    if (_isActive) {
      _startTimer();
    }
    notifyListeners();
  }

  void stopSession() {
    _timer?.cancel();
    _isActive = false;
    _isPaused = false;
    _elapsedSeconds = 0;
    _currentCycle = 1;
    _currentPhase = BreathPhase.inhale;
    _phaseSecondsRemaining = BreathPhase.inhale.durationSeconds;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused || !_isActive) return;

      _elapsedSeconds++;
      if (_elapsedSeconds >= _totalSessionSeconds) {
        _timer?.cancel();
        _isPaused = false;
        notifyListeners();
        return;
      }

      if (_phaseSecondsRemaining > 1) {
        _phaseSecondsRemaining--;
      } else {
        _advancePhase();
      }
      notifyListeners();
    });
  }

  void _advancePhase() {
    switch (_currentPhase) {
      case BreathPhase.inhale:
        _currentPhase = BreathPhase.hold;
        break;
      case BreathPhase.hold:
        _currentPhase = BreathPhase.exhale;
        break;
      case BreathPhase.exhale:
        _currentPhase = BreathPhase.rest;
        break;
      case BreathPhase.rest:
        _currentPhase = BreathPhase.inhale;
        if (_currentCycle < _totalCycles) {
          _currentCycle++;
        }
        break;
    }
    _phaseSecondsRemaining = _currentPhase.durationSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
