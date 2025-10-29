import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ============================================================================
  // PRIMARY COLORS
  // ============================================================================

  /// Primary brand color - Emerald Green
  static const Color primaryGreen = Color(0xFF4CB04F);
  static const Color secondaryGreen = Color(0xFF408f43);

  /// Secondary brand color - Blue
  static const Color primaryBlue = Color(0xFF2196F3);

  /// Primary gradient colors
  static const List<Color> primaryGradient = [
    primaryGreen,
    primaryBlue,
  ];

  // ============================================================================
  // BACKGROUND COLORS
  // ============================================================================

  /// Main app background - Pure black
  static const Color backgroundDark = Color(0xFF0D0D0D);

  /// Secondary background - Dark gray
  static const Color backgroundSecondary = Color(0xFF1A1A1A);

  /// Card/Surface background
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Input field background
  static const Color inputBackground = Color(0xFF2A2A2A);

  // ============================================================================
  // TEXT COLORS
  // ============================================================================

  /// Primary text color - Pure white
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary text color - Gray
  static const Color textSecondary = Color(0xFFB0B0B0);

  /// Tertiary text color - Lighter gray
  static const Color textTertiary = Color(0xFF808080);

  /// Disabled text color
  static const Color textDisabled = Color(0xFF4A4A4A);

  /// Placeholder text color
  static const Color textPlaceholder = Color(0xFF666666);

  // ============================================================================
  // ACCENT COLORS
  // ============================================================================

  /// Success/Positive color
  static const Color success = Color(0xFF4CAF50);

  /// Error/Negative color
  static const Color error = Color(0xFFEF5350);

  /// Warning color
  static const Color warning = Color(0xFFFFA726);

  /// Info color
  static const Color info = Color(0xFF42A5F5);

  // ============================================================================
  // UI ELEMENT COLORS
  // ============================================================================

  /// Border color for inputs and dividers
  static const Color borderColor = Color(0xFF333333);

  /// Divider color
  static const Color dividerColor = Color(0xFF2A2A2A);

  /// Icon color - Light gray
  static const Color iconColor = Color(0xFFB0B0B0);

  /// Icon color - Active state
  static const Color iconActive = Color(0xFFFFFFFF);

  // ============================================================================
  // BUTTON COLORS
  // ============================================================================

  /// Primary button background
  static const Color buttonPrimary = primaryGreen;

  /// Primary button text
  static const Color buttonPrimaryText = Color(0xFFFFFFFF);

  /// Secondary button background
  static const Color buttonSecondary = Color(0xFF1C1C1C);

  /// Secondary button text
  static const Color buttonSecondaryText = Color(0xFFFFFFFF);

  /// Disabled button background
  static const Color buttonDisabled = Color(0xFF2A2A2A);

  /// Disabled button text
  static const Color buttonDisabledText = Color(0xFF666666);

  // ============================================================================
  // SOCIAL LOGIN COLORS
  // ============================================================================

  /// GitHub button background
  static const Color githubButton = Color(0xFF2A2A2A);

  /// Google button background
  static const Color googleButton = Color(0xFF2A2A2A);

  // ============================================================================
  // SHADOW COLORS
  // ============================================================================

  /// Primary shadow color
  static Color shadowPrimary = primaryGreen.withOpacity(0.3);

  /// Secondary shadow color
  static Color shadowSecondary = Colors.black.withOpacity(0.5);

  // ============================================================================
  // GRADIENT DEFINITIONS
  // ============================================================================

  /// Logo gradient (Green to Blue)
  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: primaryGradient,
  );

  /// Primary button gradient (Green to Darker Green)
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryGreen, secondaryGreen],
  );

  /// Disabled button gradient (Gray)
  static LinearGradient disabledButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      buttonDisabled,
      buttonDisabled.withOpacity(0.8),
    ],
  );

  /// Text gradient (for special effects)
  static const LinearGradient textGradient = LinearGradient(
    colors: [
      primaryGreen,
      Color(0xFFFFFFFF),
      primaryBlue,
    ],
  );

  // ============================================================================
  // OPACITY VARIANTS
  // ============================================================================

  /// White with opacity levels
  static Color white10 = Colors.white.withOpacity(0.1);
  static Color white20 = Colors.white.withOpacity(0.2);
  static Color white30 = Colors.white.withOpacity(0.3);
  static Color white40 = Colors.white.withOpacity(0.4);
  static Color white50 = Colors.white.withOpacity(0.5);
  static Color white60 = Colors.white.withOpacity(0.6);
  static Color white70 = Colors.white.withOpacity(0.7);
  static Color white80 = Colors.white.withOpacity(0.8);
  static Color white90 = Colors.white.withOpacity(0.9);

  /// Black with opacity levels
  static Color black10 = Colors.black.withOpacity(0.1);
  static Color black20 = Colors.black.withOpacity(0.2);
  static Color black30 = Colors.black.withOpacity(0.3);
  static Color black40 = Colors.black.withOpacity(0.4);
  static Color black50 = Colors.black.withOpacity(0.5);
  static Color black60 = Colors.black.withOpacity(0.6);
  static Color black70 = Colors.black.withOpacity(0.7);
  static Color black80 = Colors.black.withOpacity(0.8);
  static Color black90 = Colors.black.withOpacity(0.9);
}
