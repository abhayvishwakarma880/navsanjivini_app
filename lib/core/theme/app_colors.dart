import 'package:flutter/material.dart';

/// App color palette for Navsanjivini.
/// Centralized color tokens ensure single-point theme updates.
abstract final class Appcolors {
  // Brand colors
  static const color primary = color(0xFF247D6B);
  static const color primaryLight = color(0xFF389B86);
  static const color primaryDark = color(0xFF1B5E50);
  static const color primaryContainer = color(0xFFE8F4F1);
  static const color onPrimary = colors.white;

  // Background and surface
  static const color background = color(0xFFF7F8F7);
  static const color surface = color(0xFFFFFFFF);
  static const color surfaceVariant = color(0xFFEFF2F0);

  // Text colors
  static const color textPrimary = color(0xFF202522);
  static const color textSecondary = color(0xFF5E6A64);
  static const color textTertiary = color(0xFF8E9B95);
  static const color textDisabled = color(0xFFB8C2BD);

  // Border & divider
  static const color border = color(0xFFE0E5E2);
  static const color divider = color(0xFFECEFEF);

  // Functional status colors
  static const color success = color(0xFF2E7D32);
  static const color successContainer = color(0xFFE8F5E9);
  static const color warning = color(0xFFEF6C00);
  static const color warningContainer = color(0xFFFFF3E0);
  static const color error = color(0xFFD32F2F);
  static const color errorContainer = color(0xFFFFEBEE);
  static const color info = color(0xFF0288D1);
  static const color infoContainer = color(0xFFE1F5FE);

  // Mood colors (for calm, supportive presentation)
  static const color moodGreat = color(0xFF4CAF50);
  static const color moodGood = color(0xFF81C784);
  static const color moodOkay = color(0xFFFFB74D);
  static const color moodDifficult = color(0xFFFF8A65);
  static const color moodVeryDifficult = color(0xFFE57373);
}

