import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Display styles - Light
  static TextStyle displayLarge = TextStyle(
    fontSize: ResFontSize.displayLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle displayMedium = TextStyle(
    fontSize: ResFontSize.displayMedium,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle displaySmall = TextStyle(
    fontSize: ResFontSize.displaySmall,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Headline styles - Light
  static TextStyle headlineLarge = TextStyle(
    fontSize: ResFontSize.headlineLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle headlineMedium = TextStyle(
    fontSize: ResFontSize.headlineMedium,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle headlineSmall = TextStyle(
    fontSize: ResFontSize.headlineSmall,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Title styles - Light
  static TextStyle titelLarge = TextStyle(
    fontSize: ResFontSize.titleLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle titelMedium = TextStyle(
    fontSize: ResFontSize.titleMedium,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static TextStyle titelSmall = TextStyle(
    fontSize: ResFontSize.titleSmall,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // Label styles - Light
  static TextStyle labelSmall = TextStyle(
    fontSize: ResFontSize.labelSmall,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF6B7280),
  );

  static TextStyle labelMedium = TextStyle(
    fontSize: ResFontSize.labelMedium,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle labelLarge = TextStyle(
    fontSize: ResFontSize.labelLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Body styles - Light
  static TextStyle bodySmall = TextStyle(
    fontSize: ResFontSize.bodySmall,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: ResFontSize.bodyMedium,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle bodyLarge = TextStyle(
    fontSize: ResFontSize.bodyLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // ==================== DARK THEME ====================

  // Display styles - Dark
  static TextStyle displayLargeDark = TextStyle(
    fontSize: ResFontSize.displayLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle displayMediumDark = TextStyle(
    fontSize: ResFontSize.displayMedium,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle displaySmallDark = TextStyle(
    fontSize: ResFontSize.displaySmall,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFE5E7EB),
  );

  // Headline styles - Dark
  static TextStyle headlineLargeDark = TextStyle(
    fontSize: ResFontSize.headlineLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle headlineMediumDark = TextStyle(
    fontSize: ResFontSize.headlineMedium,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFE5E7EB),
  );

  static TextStyle headlineSmallDark = TextStyle(
    fontSize: ResFontSize.headlineSmall,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFE5E7EB),
  );

  // Title styles - Dark
  static TextStyle titelLargeDark = TextStyle(
    fontSize: ResFontSize.titleLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle titelMediumDark = TextStyle(
    fontSize: ResFontSize.titleMedium,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static TextStyle titelSmallDark = TextStyle(
    fontSize: ResFontSize.titleSmall,
    fontWeight: FontWeight.w500,
    color: const Color(0xFFE5E7EB),
  );

  // Label styles - Dark
  static TextStyle labelSmallDark = TextStyle(
    fontSize: ResFontSize.labelSmall,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF9CA3AF),
  );

  static TextStyle labelMediumDark = TextStyle(
    fontSize: ResFontSize.labelMedium,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFE5E7EB),
  );

  static TextStyle labelLargeDark = TextStyle(
    fontSize: ResFontSize.labelLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Body styles - Dark
  static TextStyle bodySmallDark = TextStyle(
    fontSize: ResFontSize.bodySmall,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF9CA3AF),
  );

  static TextStyle bodyMediumDark = TextStyle(
    fontSize: ResFontSize.bodyMedium,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFE5E7EB),
  );

  static TextStyle bodyLargeDark = TextStyle(
    fontSize: ResFontSize.bodyLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

class ResFontSize {
  // Display styles - بزرگترین سایزها
  static double displayLarge = GetResponsiveHelper.responsiveValue(
    phone: 36.sp,
    tablet: 40.sp,
    laptop: 44.sp,
    desktop: 48.sp,
  );

  static double displayMedium = GetResponsiveHelper.responsiveValue(
    phone: 30.sp,
    tablet: 34.sp,
    laptop: 38.sp,
    desktop: 42.sp,
  );

  static double displaySmall = GetResponsiveHelper.responsiveValue(
    phone: 24.sp,
    tablet: 28.sp,
    laptop: 32.sp,
    desktop: 36.sp,
  );

  // Headline styles - برای سرتیترها
  static double headlineLarge = GetResponsiveHelper.responsiveValue(
    phone: 24.sp,
    tablet: 28.sp,
    laptop: 32.sp,
    desktop: 34.sp,
  );

  static double headlineMedium = GetResponsiveHelper.responsiveValue(
    phone: 20.sp,
    tablet: 24.sp,
    laptop: 28.sp,
    desktop: 30.sp,
  );

  static double headlineSmall = GetResponsiveHelper.responsiveValue(
    phone: 18.sp,
    tablet: 20.sp,
    laptop: 24.sp,
    desktop: 26.sp,
  );

  // Title styles - برای عنوان‌ها
  static double titleLarge = GetResponsiveHelper.responsiveValue(
    phone: 26.sp,
    tablet: 30.sp,
    laptop: 34.sp,
    desktop: 36.sp,
  );

  static double titleMedium = GetResponsiveHelper.responsiveValue(
    phone: 22.sp,
    tablet: 26.sp,
    laptop: 30.sp,
    desktop: 32.sp,
  );

  static double titleSmall = GetResponsiveHelper.responsiveValue(
    phone: 18.sp,
    tablet: 22.sp,
    laptop: 26.sp,
    desktop: 28.sp,
  );

  // Label styles - برای برچسب‌ها
  static double labelSmall = GetResponsiveHelper.responsiveValue(
    phone: 12.sp,
    tablet: 14.sp,
    laptop: 16.sp,
    desktop: 18.sp,
  );

  static double labelMedium = GetResponsiveHelper.responsiveValue(
    phone: 14.sp,
    tablet: 16.sp,
    laptop: 18.sp,
    desktop: 20.sp,
  );

  static double labelLarge = GetResponsiveHelper.responsiveValue(
    phone: 16.sp,
    tablet: 18.sp,
    laptop: 20.sp,
    desktop: 22.sp,
  );

  // Body styles - برای متن‌های اصلی
  static double bodySmall = GetResponsiveHelper.responsiveValue(
    phone: 13.sp,
    tablet: 15.sp,
    laptop: 17.sp,
    desktop: 18.sp,
  );

  static double bodyMedium = GetResponsiveHelper.responsiveValue(
    phone: 15.sp,
    tablet: 17.sp,
    laptop: 19.sp,
    desktop: 20.sp,
  );

  static double bodyLarge = GetResponsiveHelper.responsiveValue(
    phone: 17.sp,
    tablet: 19.sp,
    laptop: 21.sp,
    desktop: 22.sp,
  );
}
