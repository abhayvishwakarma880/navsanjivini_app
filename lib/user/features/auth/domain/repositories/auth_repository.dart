import '../models/auth_result.dart';
import '../models/auth_user.dart';

/// Contract interface for Authentication.
/// In production, implement this with RemoteAuthRepository (calling backend REST/GraphQL API).
/// Currently implemented by MockAuthRepository with fixed OTP and test credentials.
abstract class AuthRepository {
  /// Existing user login with phone number and password.
  Future<AuthResult> loginWithPassword({
    required String phone,
    required String password,
  });

  /// Request OTP for new registration or password reset.
  Future<AuthResult> sendOtp({
    required String phone,
  });

  /// Verify 6-digit OTP (e.g., 123456).
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
  });

  /// Complete registration by setting password and name.
  Future<AuthResult> registerWithPassword({
    required String phone,
    required String name,
    required String password,
  });

  /// Check if user has an active session.
  Future<bool> isAuthenticated();

  /// Retrieve currently signed-in user, if any.
  Future<AuthUser?> getCurrentUser();

  /// Logout and clear session.
  Future<void> logout();
}
