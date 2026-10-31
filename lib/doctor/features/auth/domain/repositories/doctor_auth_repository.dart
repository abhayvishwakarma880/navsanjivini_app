import '../models/doctor_user.dart';

/// Contract for Doctor Authentication repository.
abstract interface class DoctorAuthRepository {
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  });

  Future<void> logout();

  DoctorUser? get currentDoctor;

  bool get isAuthenticated;
}

