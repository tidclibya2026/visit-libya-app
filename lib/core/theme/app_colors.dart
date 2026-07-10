import 'package:flutter/material.dart';

/// Official Visit Libya App Visual Identity v1.0 color tokens.
///
/// Visual direction:
/// Modern Heritage Journey.
abstract final class AppColors {
  // ---------------------------------------------------------
  // Primary brand colors
  // ---------------------------------------------------------

  static const Color mediterraneanBlue = Color(0xFF0D5E9D);
  static const Color deepNavy = Color(0xFF0B1F33);
  static const Color heritageSand = Color(0xFFC8A06B);
  static const Color journeyRed = Color(0xFFB62025);

  // ---------------------------------------------------------
  // Neutral colors
  // ---------------------------------------------------------

  static const Color white = Color(0xFFFFFFFF);
  static const Color softBackground = Color(0xFFF8FAFC);
  static const Color softSand = Color(0xFFF3E6D1);
  static const Color charcoal = Color(0xFF1F2937);
  static const Color warmGray = Color(0xFF6B7280);
  static const Color borderGray = Color(0xFFE5E7EB);

  // ---------------------------------------------------------
  // Tourism supporting colors
  // ---------------------------------------------------------

  static const Color oasisGreen = Color(0xFF6F8F4E);
  static const Color seaBlue = Color(0xFF4A90C2);

  // ---------------------------------------------------------
  // Semantic colors
  // ---------------------------------------------------------

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFC62828);
  static const Color info = Color(0xFF0284C7);

  // ---------------------------------------------------------
  // Text colors
  // ---------------------------------------------------------

  static const Color textPrimary = deepNavy;
  static const Color textSecondary = warmGray;
  static const Color textOnPrimary = white;

  // ---------------------------------------------------------
  // Surface colors
  // ---------------------------------------------------------

  static const Color surface = white;
  static const Color surfaceMuted = softBackground;
  static const Color surfaceHeritage = softSand;

  // ---------------------------------------------------------
  // Backward-friendly aliases
  // ---------------------------------------------------------

  static const Color primaryBlue = mediterraneanBlue;
  static const Color background = softBackground;
  static const Color border = borderGray;
}
