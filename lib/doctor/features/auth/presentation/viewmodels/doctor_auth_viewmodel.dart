import 'package:flutter/material.dart';
import '../../domain/repositories/doctor_auth_repository.dart';

/// ViewModel for Doctor Login Screen.
class DoctorAuthViewModel extends ChangeNotifier {
  final DoctorAuthRepository _repository;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  DoctorAuthViewModel(this._repository);

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      _errorMessage = 'Please enter your email address.';
      notifyListeners();
      return false;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _errorMessage = 'Please enter a valid email address.';
      notifyListeners();
      return false;
    }

    if (password.isEmpty) {
      _errorMessage = 'Please enter your password.';
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.loginWithEmail(
        email: email,
        password: password,
      );

      _isLoading = false;
      if (success) {
        _successMessage = 'Doctor logged in successfully.';
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

