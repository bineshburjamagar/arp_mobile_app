import 'dart:ui';

class AppColors {
  static const Color primaryTeal = Color(0xFF0D9488);

  static const Color lightTeal = Color(0xFF2DD4BF);

  static const Color secondaryEmerald = Color(0xFF10B981);

  // --- Status & Feedback Colors ---

  /// Used for critical warnings, errors, and the emergency notice (Red 600).
  static const Color crisisRed = Color(0xFFDC2626);

  /// A very light background color for warning sections (Red 100).
  static const Color lightCrisisBackground = Color(0xFFFEE2E2);

  /// Used for success messages or positive confirmations.
  static const Color successGreen = Color(0xFF16A34A);

  // --- Neutral & Utility Colors ---

  /// Pure white for text on dark backgrounds and main component surfaces.
  static const Color pureWhite = Color(0xFFFFFFFF);

  /// The main background color for screens and containers (Gray 50).
  static const Color backgroundLight = Color(0xFFF9FAFB);

  /// Dark gray for main body text and headings (Gray 800).
  static const Color textPrimary = Color(0xFF1F2937);

  /// Medium gray for secondary text, placeholder text, and borders (Gray 400).
  static const Color textSecondary = Color(0xFF9CA3AF);

  /// Light gray for dividers and borders (Gray 200).
  static const Color borderLight = Color(0xFFE5E7EB);
}
