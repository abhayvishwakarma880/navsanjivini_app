import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/doctor/repositories/mock_doctor_auth_repository.dart';
import 'package:app/doctor/viewmodels/doctor_auth_viewmodel.dart';
import 'package:app/doctor/views/doctor_login_screen.dart';

void main() {
  late InMemoryStorageService storageService;
  late LanguageController languageController;
  late MockDoctorAuthRepository doctorRepo;
  late DoctorAuthViewModel viewModel;

  setUp(() {
    storageService = InMemoryStorageService();
    languageController = LanguageController(storageService);
    doctorRepo = MockDoctorAuthRepository(storageService);
    viewModel = DoctorAuthViewModel(doctorRepo);
  });

  Widget buildTestWidget({VoidCallback? onSuccess, VoidCallback? onSwitch}) {
    return LanguageScope(
      controller: languageController,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: DoctorLoginScreen(
          viewModel: viewModel,
          onAuthSuccess: onSuccess ?? () {},
          onNavigateToUserLogin: onSwitch ?? () {},
        ),
      ),
    );
  }

  testWidgets('renders Doctor Login screen with email and password fields', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Doctor Login'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(2)); // Email & Password
    expect(find.text('Doctor Log In'), findsOneWidget);
    expect(find.text('User Login'), findsOneWidget);
  });

  testWidgets('shows validation error when fields are empty', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Tap Login without typing
    await tester.tap(find.text('Doctor Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your email address.'), findsOneWidget);
  });

  testWidgets('successful doctor login calls onAuthSuccess', (tester) async {
    bool loginSuccess = false;
    await tester.pumpWidget(buildTestWidget(onSuccess: () => loginSuccess = true));
    await tester.pumpAndSettle();

    viewModel.emailController.text = 'doctor@clinic.com';
    viewModel.passwordController.text = 'password123';

    await tester.tap(find.text('Doctor Log In'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(loginSuccess, isTrue);
  });
}

