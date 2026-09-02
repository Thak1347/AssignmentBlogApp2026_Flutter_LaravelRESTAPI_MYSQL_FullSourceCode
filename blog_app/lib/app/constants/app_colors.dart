import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color secondary = Color(0xFF10B981);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkDivider = Color(0xFF334155);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
}
