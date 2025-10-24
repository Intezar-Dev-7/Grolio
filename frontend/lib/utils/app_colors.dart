import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Darker Teal Gradient
  static const Color primaryDark = Color(0xFF01A171); // Dark teal
  static const Color primary = Color(0xFF00BFA5);     // Medium teal
  static const Color primaryLight = Color(0xFFE8F5F3);
  static const Color secondary = Color(0xFF2196F3);

  // Button Gradient Colors
  static const Color buttonGradientStart = Color(0xFF00B97A); // Darker teal
  static const Color buttonGradientEnd = Color(0xFF009B67);   // Dark teal

  // Accent Colors
  static const Color orange = Color(0xFFFF6F00);
  static const Color yellow = Color(0xFFFFB300);
  static const Color purple = Color(0xFF9C27B0);
  static const Color pink = Color(0xFFE91E63);
  static const Color red = Color(0xFFFF0000);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);

  // Background Colors
  static const Color background = Color(0xFFE8F5F3);
  static const Color cardBackground = Colors.white;

  // Other Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black87;
  static const Color grey = Color(0xFFBDBDBD);
  static const Color greyLight = Color(0xFFE0E0E0);

  // Button Gradient
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [buttonGradientStart, buttonGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}