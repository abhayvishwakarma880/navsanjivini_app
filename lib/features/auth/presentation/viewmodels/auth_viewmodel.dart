import 'package:flutter/material.dart';
import '../../domain/models/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthMode { login, register }

enum RegisterStep { enterPhone, verifyOtp, createPassword }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthMode _authMode = AuthMode.login;
  RegisterStep _registerStep = RegisterStep.enterPhone;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Text Controllers
  final TextEditingController loginPhoneController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final TextEditingController registerPhoneController = TextEditingController();
  final TextEditingController registerNameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();
  final TextEditingController registerConfirmPasswordController = TextEditingController();

  // Visibility Toggles
  bool _obscureLoginPassword = true;
  bool _obscureRegisterPassword = true;
  bool _obscureRegisterConfirmPassword = true;

  AuthViewModel(this._authRepository);

  AuthMode get authMode => _authMode;
  RegisterStep get registerStep => _registerStep;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  bool get obscureLoginPassword => _obscureLoginPassword;
  bool get obscureRegisterPassword => _obscureRegisterPassword;
  bool get obscureRegisterConfirmPassword => _obscureRegisterConfirmPassword;

  void toggleAuthMode(AuthMode mode) {
    _authMode = mode;
    _errorMessage = null;
    _successMessage = null;
    if (mode == AuthMode.register) {
      _registerStep = RegisterStep.enterPhone;
    }
    notifyListeners();
  }

  void toggleLoginPasswordVisibility() {
    _obscureLoginPassword = !_obscureLoginPassword;
    notifyListeners();
  }

  void toggleRegisterPasswordVisibility() {
    _obscureRegisterPassword = !_obscureRegisterPassword;
    notifyListeners();
  }

  void toggleRegisterConfirmPasswordVisibility() {
    _obscureRegisterConfirmPassword = !_obscureRegisterConfirmPassword;
    notifyListeners();
  }

  void setRegisterStep(RegisterStep step) {
    _registerStep = step;
    _errorMessage = null;
    notifyListeners();
  }

  /// Existing user login with Phone & Password
  Future<bool> login() async {
    final phone = loginPhoneController.text.trim();
    final password = loginPasswordController.text;

    if (!_isValidIndianPhone(phone)) {
      _setError('Please enter a valid 10-digit mobile number');
      return false;
    }

    if (password.length < 6) {
      _setError('Password must be at least 6 characters');
      return false;
    }

    _setLoading(true);
    final result = await _authRepository.loginWithPassword(
      phone: phone,
      password: password,
    );
    _setLoading(false);

    return switch (result) {
      AuthSuccess(message: final msg) => () {
          _errorMessage = null;
          _successMessage = msg ?? 'Login successful!';
          notifyListeners();
          return true;
        }(),
      AuthFailure(error: final err) => () {
          _setError(err);
          return false;
        }(),
    };
  }

  /// Register Step 1: Send OTP to Phone
  Future<bool> requestRegistrationOtp() async {
    final phone = registerPhoneController.text.trim();

    if (!_isValidIndianPhone(phone)) {
      _setError('Please enter a valid 10-digit Indian mobile number');
      return false;
    }

    _setLoading(true);
    final result = await _authRepository.sendOtp(phone: phone);
    _setLoading(false);

    return switch (result) {
      AuthSuccess(message: final msg) => () {
          _errorMessage = null;
          _successMessage = msg;
          _registerStep = RegisterStep.verifyOtp;
          notifyListeners();
          return true;
        }(),
      AuthFailure(error: final err) => () {
          _setError(err);
          return false;
        }(),
    };
  }

  /// Register Step 2: Verify 6-digit OTP (123456)
  Future<bool> verifyRegistrationOtp() async {
    final phone = registerPhoneController.text.trim();
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      _setError('Please enter the 6-digit OTP');
      return false;
    }

    _setLoading(true);
    final result = await _authRepository.verifyOtp(phone: phone, otp: otp);
    _setLoading(false);

    return switch (result) {
      AuthSuccess() => () {
          _errorMessage = null;
          _registerStep = RegisterStep.createPassword;
          notifyListeners();
          return true;
        }(),
      AuthFailure(error: final err) => () {
          _setError(err);
          return false;
        }(),
    };
  }

  /// Register Step 3: Create password & finish registration
  Future<bool> completeRegistration() async {
    final phone = registerPhoneController.text.trim();
    final name = registerNameController.text.trim();
    final password = registerPasswordController.text;
    final confirmPassword = registerConfirmPasswordController.text;

    if (password.length < 6) {
      _setError('Password must be at least 6 characters');
      return false;
    }

    if (password != confirmPassword) {
      _setError('Passwords do not match');
      return false;
    }

    _setLoading(true);
    final result = await _authRepository.registerWithPassword(
      phone: phone,
      name: name,
      password: password,
    );
    _setLoading(false);

    return switch (result) {
      AuthSuccess(message: final msg) => () {
          _errorMessage = null;
          _successMessage = msg ?? 'Account created successfully!';
          notifyListeners();
          return true;
        }(),
      AuthFailure(error: final err) => () {
          _setError(err);
          return false;
        }(),
    };
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _successMessage = null;
    notifyListeners();
  }

  bool _isValidIndianPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp(r'^91'), '');
    return RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned);
  }

  @override
  void dispose() {
    loginPhoneController.dispose();
    loginPasswordController.dispose();
    registerPhoneController.dispose();
    registerNameController.dispose();
    otpController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    super.dispose();
  }
}
