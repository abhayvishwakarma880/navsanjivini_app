import 'package:app/core/storage/storage_service.dart';
import '../../domain/models/doctor_user.dart';
import '../../domain/repositories/doctor_auth_repository.dart';

/// In-memory/mock implementation of DoctorAuthRepository.
class MockDoctorAuthRepository implements DoctorAuthRepository {
  final StorageService _storageService;
  DoctorUser? _currentDoctor;

  MockDoctorAuthRepository(this._storageService);

  @override
  DoctorUser? get currentDoctor => _currentDoctor;

  @override
  bool get isAuthenticated => _currentDoctor != null;

  @override
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    // Simulate brief network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Validate email format
    final cleanEmail = email.trim();
    if (!cleanEmail.contains('@') || !cleanEmail.contains('.')) {
      return false;
    }

    if (password.trim().length < 6) {
      return false;
    }

    _currentDoctor = DoctorUser(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Dr. ${cleanEmail.split('@').first}',
      email: cleanEmail,
    );

    await _storageService.setString('doctor_id', _currentDoctor!.id);
    await _storageService.setString('doctor_email', _currentDoctor!.email);
    return true;
  }

  @override
  Future<void> logout() async {
    _currentDoctor = null;
    await _storageService.remove('doctor_id');
    await _storageService.remove('doctor_email');
  }
}

