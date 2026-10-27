import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/common/views/welcome_screen.dart';

void main() {
  testWidgets('WelcomeScreen renders exact reference UI elements accurately', (tester) async {
    final storage = InMemoryStorageService();
    final controller = LanguageController(storage);

    bool continueTapped = false;

    await tester.pumpWidget(
      LanguageScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: WelcomeScreen(
            onContinue: () {
              continueTapped = true;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Brand Title & Subtitle
    expect(find.text('Navsanjivini'), findsOneWidget);
    expect(find.text('A gentle space to feel better'), findsOneWidget);

    // Verify Eco leaf icon in divider
    expect(find.byIcon(Icons.eco_rounded), findsOneWidget);

    // Verify Body Description
    expect(find.text('Your companion for everyday\nemotional well-being.'), findsOneWidget);

    // Verify Get Started button
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

    // Tap Get Started button
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(continueTapped, isTrue);
  });
}

