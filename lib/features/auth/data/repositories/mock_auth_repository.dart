import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/storage/storage_service.dart';
import '../../domain/models/auth_result.dart';
import '../../domain/models/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Temporary Mock/Local Implementation of [AuthRepository].
///
/// Behavior:
/// - Accepts any valid 10-digit Indian mobile number (e.g., starts with 6, 7, 8, 9).
/// - Default fixed OTP is '123456'.
/// - Existing registered phone numbers can log in directly with their password.
/// - Stores session token in [StorageService].
///
/// NOTE: When backend API is ready, replace this with a RemoteAuthRepository
/// using Dio/Http without touching any UI code!
class MockAuthRepository implements AuthRepository {
  final StorageService _storageService;

  // In-memory store of registered users (phone -> user)
  static final Map<String, _RegisteredAccount> _accounts = {
    // Demo pre-registered user
    '9876543210': _RegisteredAccount(
      user: const AuthUser(
        id: 'usr_demo_1',
        phone: '9876543210',
        name: 'Abhay',
        token: 'mock_jwt_token_9876543210',
      ),
      password: 'password123',
    ),
  };

  MockAuthRepository(this._storageService);

  @override
  Future<AuthResult> loginWithPassword({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network latency

    final cleanedPhone = _cleanPhone(phone);
    if (!_isValidIndianPhone(cleanedPhone)) {
      return const AuthFailure('Invalid Indian mobile number. Must be 10 digits.');
    }

    if (password.length < 6) {
      return const AuthFailure('Password must be at least 6 characters.');
    }

    final account = _accounts[cleanedPhone];
    if (account != null) {
      if (account.password == password) {
        await _saveSession(account.user);
        return AuthSuccess(user: account.user, message: 'Welcome back!');
      } else {
        return const AuthFailure('Incorrect password. Please try again.');
      }
    }

    // For ease of demo/development:
    // If phone is not in mock map, auto-allow with a generated account
    final newUser = AuthUser(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      phone: cleanedPhone,
      name: 'User $cleanedPhone',
      token: 'mock_jwt_token_$cleanedPhone',
    );
    _accounts[cleanedPhone] = _RegisteredAccount(user: newUser, password: password);
    await _saveSession(newUser);
    return AuthSuccess(user: newUser, message: 'Login successful.');
  }

  @override
  Future<AuthResult> sendOtp({required String phone}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final cleanedPhone = _cleanPhone(phone);
    if (!_isValidIndianPhone(cleanedPhone)) {
      return const AuthFailure('Invalid Indian mobile number. Must be 10 digits.');
    }

    // In a real API, backend triggers SMS gateway (Twilio, Fast2SMS, MSG91, Firebase)
    return const AuthSuccess(message: 'OTP sent! Use demo code: 123456');
  }

  @override
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final cleanedOtp = otp.trim();
    // Fixed OTP 123456 as requested
    if (cleanedOtp == '123456') {
      return const AuthSuccess(message: 'OTP verified successfully.');
    } else {
      return const AuthFailure('Invalid OTP. Please enter 123456.');
    }
  }

  @override
  Future<AuthResult> registerWithPassword({
    required String phone,
    required String name,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final cleanedPhone = _cleanPhone(phone);
    if (!_isValidIndianPhone(cleanedPhone)) {
      return const AuthFailure('Invalid mobile number.');
    }

    if (password.length < 6) {
      return const AuthFailure('Password must be at least 6 characters.');
    }

    final user = AuthUser(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      phone: cleanedPhone,
      name: name.trim().isEmpty ? 'Navsanjivini Member' : name.trim(),
      token: 'mock_jwt_token_$cleanedPhone',
    );

    _accounts[cleanedPhone] = _RegisteredAccount(user: user, password: password);
    await _saveSession(user);

    return AuthSuccess(user: user, message: 'Account created successfully!');
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storageService.getString(AppConstants.keyAuthToken);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final token = await _storageService.getString(AppConstants.keyAuthToken);
    if (token == null) return null;
    return const AuthUser(
      id: 'usr_current',
      phone: '9876543210',
      name: 'User',
    );
  }

  @override
  Future<void> logout() async {
    await _storageService.remove(AppConstants.keyAuthToken);
  }

  Future<void> _saveSession(AuthUser user) async {
    if (user.token != null) {
      await _storageService.setString(AppConstants.keyAuthToken, user.token!);
    }
  }

  String _cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp(r'^91'), '');
  }

  bool _isValidIndianPhone(String phone) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
  }
}

class _RegisteredAccount {
  final AuthUser user;
  final String password;

  const _RegisteredAccount({required this.user, required this.password});
}
