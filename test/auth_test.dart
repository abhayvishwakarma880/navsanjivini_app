import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:app/features/auth/domain/models/auth_result.dart';
import 'package:app/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:app/features/auth/presentation/views/auth_screen.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/localization/language_scope.dart';

void main() {
  group('MockAuthRepository Tests', () {
    late InMemoryStorageService storage;
    late MockAuthRepository repo;

    setUp(() {
      storage = InMemoryStorageService();
      repo = MockAuthRepository(storage);
    });

    test('Valid Indian number and password logs in successfully', () async {
      final result = await repo.loginWithPassword(
        phone: '9876543210',
        password: 'password123',
      );
      expect(result, isA<AuthSuccess>());
    });

    test('Invalid phone number fails validation', () async {
      final result = await repo.loginWithPassword(
        phone: '12345',
        password: 'password123',
      );
      expect(result, isA<AuthFailure>());
    });

    test('Fixed OTP 123456 passes verification', () async {
      final result = await repo.verifyOtp(phone: '9876543210', otp: '123456');
      expect(result, isA<AuthSuccess>());
    });

    test('Wrong OTP fails verification', () async {
      final result = await repo.verifyOtp(phone: '9876543210', otp: '999999');
      expect(result, isA<AuthFailure>());
    });

    test('Registering new user with password succeeds', () async {
      final result = await repo.registerWithPassword(
        phone: '9811122233',
        name: 'Abhay',
        password: 'securePass123',
      );
      expect(result, isA<AuthSuccess>());
    });
  });

  group('AuthViewModel State Flow Tests', () {
    late InMemoryStorageService storage;
    late MockAuthRepository repo;
    late AuthViewModel vm;

    setUp(() {
      storage = InMemoryStorageService();
      repo = MockAuthRepository(storage);
      vm = AuthViewModel(repo);
    });

    tearDown(() => vm.dispose());

    test('Toggle between Login and Register modes', () {
      expect(vm.authMode, AuthMode.login);
      vm.toggleAuthMode(AuthMode.register);
      expect(vm.authMode, AuthMode.register);
      expect(vm.registerStep, RegisterStep.enterPhone);
    });

    test('Full Registration Flow: Phone -> OTP -> Password -> Success', () async {
      vm.toggleAuthMode(AuthMode.register);

      // Step 1: Send OTP
      vm.registerNameController.text = 'Rahul';
      vm.registerPhoneController.text = '9812345678';
      final otpSent = await vm.requestRegistrationOtp();
      expect(otpSent, isTrue);
      expect(vm.registerStep, RegisterStep.verifyOtp);

      // Step 2: Verify OTP
      vm.otpController.text = '123456';
      final otpVerified = await vm.verifyRegistrationOtp();
      expect(otpVerified, isTrue);
      expect(vm.registerStep, RegisterStep.createPassword);

      // Step 3: Set Password
      vm.registerPasswordController.text = 'mypassword123';
      vm.registerConfirmPasswordController.text = 'mypassword123';
      final registered = await vm.completeRegistration();
      expect(registered, isTrue);
    });
  });

  group('AuthScreen UI Widget Tests', () {
    testWidgets('Renders Login form by default and switches to Register', (tester) async {
      final storage = InMemoryStorageService();
      final repo = MockAuthRepository(storage);
      final vm = AuthViewModel(repo);
      final langController = LanguageController(storage);

      await tester.pumpWidget(
        LanguageScope(
          controller: langController,
          child: MaterialApp(
            home: AuthScreen(
              viewModel: vm,
              onAuthSuccess: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check Login Elements
      expect(find.text('Log In'), findsWidgets);
      expect(find.text('Mobile Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Tap Register Tab
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Check Register Elements
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Send OTP'), findsOneWidget);
      expect(find.text('Demo OTP: 123456'), findsOneWidget);
    });
  });
}
