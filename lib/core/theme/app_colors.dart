import 'package:flutter/material.dart';

/// App color palette for Navsanjivini.
/// Centralized color tokens ensure single-point theme updates.
abstract final class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF247D6B);
  static const Color primaryLight = Color(0xFF389B86);
  static const Color primaryDark = Color(0xFF1B5E50);
  static const Color primaryContainer = Color(0xFFE8F4F1);
  static const Color onPrimary = Colors.white;

  // Background and surface
  static const Color background = Color(0xFFF7F8F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEFF2F0);

  // Text colors
  static const Color textPrimary = Color(0xFF202522);
  static const Color textSecondary = Color(0xFF5E6A64);
  static const Color textTertiary = Color(0xFF8E9B95);
  static const Color textDisabled = Color(0xFFB8C2BD);

  // Border & divider
  static const Color border = Color(0xFFE0E5E2);
  static const Color divider = Color(0xFFECEFEF);

  // Functional status colors
  static const Color success = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFEF6C00);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF0288D1);
  static const Color infoContainer = Color(0xFFE1F5FE);

  // Mood colors (for calm, supportive presentation)
  static const Color moodGreat = Color(0xFF4CAF50);
  static const Color moodGood = Color(0xFF81C784);
  static const Color moodOkay = Color(0xFFFFB74D);
  static const Color moodDifficult = Color(0xFFFF8A65);
  static const Color moodVeryDifficult = Color(0xFFE57373);
}
