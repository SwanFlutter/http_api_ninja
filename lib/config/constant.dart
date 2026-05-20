import 'package:flutter/material.dart';

/// Text Style Helper - تمام استایل‌های متن برای تم روشن و تیره
class TextStyleHelper {
  // Light Theme Text Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    letterSpacing: 0.5,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    letterSpacing: 0.3,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
    letterSpacing: 0.2,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
    height: 1.5,
  );

  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Dark Theme Text Styles
  static const TextStyle titleLargeDark = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle titleMediumDark = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static const TextStyle titleSmallDark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle labelLargeDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMediumDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle labelSmallDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFFB0B0B0),
  );

  static const TextStyle bodyLargeDark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    height: 1.5,
  );

  static const TextStyle bodyMediumDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    height: 1.5,
  );

  static const TextStyle bodySmallDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFFB0B0B0),
    height: 1.5,
  );

  static const TextStyle displayLargeDark = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMediumDark = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle displaySmallDark = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle headlineLargeDark = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle headlineMediumDark = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle headlineSmallDark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

/// App Constants
class AppConstants {
  // Padding & Spacing
  static const double paddingXSmall = 4;
  static const double paddingSmall = 8;
  static const double paddingMedium = 16;
  static const double paddingLarge = 24;
  static const double paddingXLarge = 32;

  // Border Radius
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 12;
  static const double radiusXLarge = 16;

  // Icon Sizes
  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 24;
  static const double iconSizeLarge = 32;
  static const double iconSizeXLarge = 48;

  // Animation Durations
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
}
