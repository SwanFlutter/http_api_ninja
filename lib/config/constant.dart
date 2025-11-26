import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Display styles - Light (رنگ مشکی برای تم روشن)
  static TextStyle displayLarge = TextStyle(
    fontSize: ResFontSize.displayLarge,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle displayMedium = TextStyle(
    fontSize: ResFontSize.displayMedium,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle displaySmall = TextStyle(
    fontSize: ResFontSize.displaySmall,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Headline styles - Light
  static TextStyle headlineLarge = TextStyle(
    fontSize: ResFontSize.headlineLarge,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle headlineMedium = TextStyle(
    fontSize: ResFontSize.headlineMedium,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle headlineSmall = TextStyle(
    fontSize: ResFontSize.headlineSmall,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Title styles - Light
  static TextStyle titleLarge = TextStyle(
    fontSize: ResFontSize.titleLarge,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: ResFontSize.titleMedium,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle titleSmall = TextStyle(
    fontSize: ResFontSize.titleSmall,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  // Label styles - Light
  static TextStyle labelSmall = TextStyle(
    fontSize: ResFontSize.labelSmall,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF4B5563),
  );

  static TextStyle labelMedium = TextStyle(
    fontSize: ResFontSize.labelMedium,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static TextStyle labelLarge = TextStyle(
    fontSize: ResFontSize.labelLarge,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Body styles - Light
  static TextStyle bodySmall = TextStyle(
    fontSize: ResFontSize.bodySmall,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: ResFontSize.bodyMedium,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static TextStyle bodyLarge = TextStyle(
    fontSize: ResFontSize.bodyLarge,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  // ==================== DARK THEME ====================

  // Display styles - Dark (رنگ سفید برای تم تاریک)
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
    color: Colors.white,
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
    color: Colors.white,
  );

  static TextStyle headlineSmallDark = TextStyle(
    fontSize: ResFontSize.headlineSmall,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Title styles - Dark
  static TextStyle titleLargeDark = TextStyle(
    fontSize: ResFontSize.titleLarge,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle titleMediumDark = TextStyle(
    fontSize: ResFontSize.titleMedium,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle titleSmallDark = TextStyle(
    fontSize: ResFontSize.titleSmall,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // Label styles - Dark
  static TextStyle labelSmallDark = TextStyle(
    fontSize: ResFontSize.labelSmall,
    fontWeight: FontWeight.w400,
    color: const Color(0xFFD1D5DB),
  );

  static TextStyle labelMediumDark = TextStyle(
    fontSize: ResFontSize.labelMedium,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle labelLargeDark = TextStyle(
    fontSize: ResFontSize.labelLarge,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Body styles - Dark
  static TextStyle bodySmallDark = TextStyle(
    fontSize: ResFontSize.bodySmall,
    fontWeight: FontWeight.w400,
    color: const Color(0xFFE5E7EB),
  );

  static TextStyle bodyMediumDark = TextStyle(
    fontSize: ResFontSize.bodyMedium,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static TextStyle bodyLargeDark = TextStyle(
    fontSize: ResFontSize.bodyLarge,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

class ResFontSize {
  // Display styles - بزرگترین سایزها (برای عناوین اصلی)
  static double displayLarge = GetResponsiveHelper.responsiveValue(
    phone: 28.sp,
    tablet: 32.sp,
    laptop: 36.sp,
    desktop: 40.sp,
  );

  static double displayMedium = GetResponsiveHelper.responsiveValue(
    phone: 24.sp,
    tablet: 26.sp,
    laptop: 28.sp,
    desktop: 32.sp,
  );

  static double displaySmall = GetResponsiveHelper.responsiveValue(
    phone: 20.sp,
    tablet: 22.sp,
    laptop: 24.sp,
    desktop: 26.sp,
  );

  // Headline styles - برای سرتیترها
  static double headlineLarge = GetResponsiveHelper.responsiveValue(
    phone: 18.sp,
    tablet: 20.sp,
    laptop: 22.sp,
    desktop: 24.sp,
  );

  static double headlineMedium = GetResponsiveHelper.responsiveValue(
    phone: 16.sp,
    tablet: 17.sp,
    laptop: 18.sp,
    desktop: 20.sp,
  );

  static double headlineSmall = GetResponsiveHelper.responsiveValue(
    phone: 14.sp,
    tablet: 15.sp,
    laptop: 16.sp,
    desktop: 18.sp,
  );

  // Title styles - برای عنوان‌ها
  static double titleLarge = GetResponsiveHelper.responsiveValue(
    phone: 18.sp,
    tablet: 20.sp,
    laptop: 22.sp,
    desktop: 24.sp,
  );

  static double titleMedium = GetResponsiveHelper.responsiveValue(
    phone: 15.sp,
    tablet: 16.sp,
    laptop: 17.sp,
    desktop: 18.sp,
  );

  static double titleSmall = GetResponsiveHelper.responsiveValue(
    phone: 13.sp,
    tablet: 14.sp,
    laptop: 15.sp,
    desktop: 16.sp,
  );

  // Label styles - برای برچسب‌ها
  static double labelSmall = GetResponsiveHelper.responsiveValue(
    phone: 10.sp,
    tablet: 11.sp,
    laptop: 11.sp,
    desktop: 12.sp,
  );

  static double labelMedium = GetResponsiveHelper.responsiveValue(
    phone: 11.sp,
    tablet: 12.sp,
    laptop: 12.sp,
    desktop: 13.sp,
  );

  static double labelLarge = GetResponsiveHelper.responsiveValue(
    phone: 12.sp,
    tablet: 13.sp,
    laptop: 14.sp,
    desktop: 14.sp,
  );

  // Body styles - برای متن‌های اصلی
  static double bodySmall = GetResponsiveHelper.responsiveValue(
    phone: 12.sp,
    tablet: 12.sp,
    laptop: 13.sp,
    desktop: 13.sp,
  );

  static double bodyMedium = GetResponsiveHelper.responsiveValue(
    phone: 13.sp,
    tablet: 14.sp,
    laptop: 14.sp,
    desktop: 14.sp,
  );

  static double bodyLarge = GetResponsiveHelper.responsiveValue(
    phone: 14.sp,
    tablet: 15.sp,
    laptop: 16.sp,
    desktop: 16.sp,
  );
}
