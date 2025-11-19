import 'package:flutter/material.dart';

import '../config/constant.dart';

// Thunder Client inspired colors
const primaryColor = Color(0xFFFF6B9D);
const primaryColorLight = Color(0xFFFF8FB3);
const primaryColorDark = Color(0xFFE5527D);
const secondaryColor = Color(0xFF3C3C3C);
const bgColorLight = Color(0xFFF5F5F5);
const bgColorDark = Color(0xFF1E1E1E);
const surfaceColorLight = Color(0xFFFFFFFF);
const surfaceColorDark = Color(0xFF252526);

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColorLight,
    ),
    scaffoldBackgroundColor: bgColorLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        elevation: 2,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyleHelper.titelLarge.copyWith(color: Colors.black),
      titleMedium: TextStyleHelper.titelMedium.copyWith(color: Colors.black87),
      titleSmall: TextStyleHelper.titelSmall.copyWith(color: Colors.black87),

      labelSmall: TextStyleHelper.labelSmall.copyWith(color: Colors.grey[700]),
      labelMedium: TextStyleHelper.labelMedium.copyWith(color: Colors.black87),
      labelLarge: TextStyleHelper.labelLarge.copyWith(color: Colors.black),

      bodySmall: TextStyleHelper.bodySmall.copyWith(color: Colors.grey[800]),
      bodyMedium: TextStyleHelper.bodyMedium.copyWith(color: Colors.black87),
      bodyLarge: TextStyleHelper.bodyLarge.copyWith(color: Colors.black),

      displayLarge: TextStyleHelper.displayLarge.copyWith(color: Colors.black),
      displayMedium: TextStyleHelper.displayMedium.copyWith(
        color: Colors.black,
      ),
      displaySmall: TextStyleHelper.displaySmall.copyWith(
        color: Colors.black87,
      ),

      headlineLarge: TextStyleHelper.displaySmall.copyWith(color: Colors.black),
      headlineMedium: TextStyleHelper.headlineMedium.copyWith(
        color: Colors.black87,
      ),
      headlineSmall: TextStyleHelper.headlineSmall.copyWith(
        color: Colors.black87,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14, // اندازه فونت برای hint
      ),
      labelStyle: const TextStyle(
        color: primaryColor,
        fontSize: 12, // اندازه فونت برای label
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    cardTheme: CardThemeData(
      color: surfaceColorLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColorLight,
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF9CA3AF),
      type: BottomNavigationBarType.fixed,
      elevation: 2,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade300;
        }
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade200;
        }
        if (states.contains(WidgetState.selected)) {
          return primaryColor.withValues(alpha: 0.5);
        }
        return Colors.grey.shade300;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade300;
        }
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade300;
        }
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColor,
      inactiveTrackColor: primaryColor.withValues(alpha: 0.2),
      thumbColor: primaryColor,
      overlayColor: primaryColor.withValues(alpha: 0.1),
      valueIndicatorColor: primaryColor,
      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: primaryColor.withValues(alpha: 0.7),
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      indicator: UnderlineTabIndicator(
        borderSide: const BorderSide(color: primaryColor, width: 2),
        insets: const EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade200,
      deleteIconColor: Colors.grey.shade700,
      disabledColor: Colors.grey.shade300,
      selectedColor: primaryColor.withValues(alpha: 0.2),
      secondarySelectedColor: primaryColor.withValues(alpha: 0.1),
      shadowColor: Colors.transparent,
      selectedShadowColor: Colors.transparent,
      checkmarkColor: primaryColor,
      labelStyle: TextStyle(color: Colors.grey.shade800),
      secondaryLabelStyle: TextStyle(color: Colors.grey.shade800),
      brightness: Brightness.light,
      elevation: 0,
      pressElevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: BorderSide(color: Colors.grey.shade300),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E7EB),
      thickness: 1,
      space: 1,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColorDark,
    ),
    scaffoldBackgroundColor: bgColorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColorDark,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColorLight,
        side: const BorderSide(color: primaryColorLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    textTheme: TextTheme(
      // Dark theme text styles using TextStyleHelper
      titleLarge: TextStyleHelper.titelLarge.copyWith(color: Colors.white),
      titleMedium: TextStyleHelper.titelMedium.copyWith(color: Colors.white),
      titleSmall: TextStyleHelper.titelSmall.copyWith(color: Color(0xFFE2E8F0)),

      // label styles for dark theme
      labelSmall: TextStyleHelper.labelSmall.copyWith(color: Color(0xFF94A3B8)),
      labelMedium: TextStyleHelper.labelMedium.copyWith(
        color: Color(0xFFCBD5E1),
      ),
      labelLarge: TextStyleHelper.labelLarge.copyWith(color: Colors.white),

      // body styles for dark theme
      bodySmall: TextStyleHelper.bodySmall.copyWith(color: Color(0xFF94A3B8)),
      bodyMedium: TextStyleHelper.bodyMedium.copyWith(color: Color(0xFFCBD5E1)),
      bodyLarge: TextStyleHelper.bodyLarge.copyWith(color: Colors.white),

      displayLarge: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE2E8F0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceColorDark,
      filled: true,

      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF334155)),
        borderRadius: BorderRadius.circular(8),
      ),
      hintStyle: TextStyle(
        color: Color(0xFF64748B),
        fontSize: 14, // اندازه فونت برای hint
      ),
      labelStyle: const TextStyle(
        color: primaryColorLight,
        fontSize: 12, // اندازه فونت برای label
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColorLight, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF334155)),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceColorDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceColorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColorDark,
      selectedItemColor: primaryColorLight,
      unselectedItemColor: Color(0xFF9CA3AF),
      type: BottomNavigationBarType.fixed,
      elevation: 2,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade600;
        }
        if (states.contains(WidgetState.selected)) {
          return primaryColorLight;
        }
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade700;
        }
        if (states.contains(WidgetState.selected)) {
          return primaryColorLight.withValues(alpha: 0.5);
        }
        return Colors.grey.shade600;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade600;
        }
        if (states.contains(WidgetState.selected)) {
          return primaryColorLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade600;
        }
        if (states.contains(WidgetState.selected)) {
          return primaryColorLight;
        }
        return Colors.transparent;
      }),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColorLight,
      inactiveTrackColor: primaryColorLight.withValues(alpha: 0.2),
      thumbColor: primaryColorLight,
      overlayColor: primaryColorLight.withValues(alpha: 0.1),
      valueIndicatorColor: primaryColorLight,
      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      indicator: UnderlineTabIndicator(
        borderSide: const BorderSide(color: primaryColorLight, width: 2),
        insets: const EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF334155),
      deleteIconColor: const Color(0xFFCBD5E1),
      disabledColor: const Color(0xFF475569),
      selectedColor: primaryColor.withValues(alpha: 0.3),
      secondarySelectedColor: primaryColor.withValues(alpha: 0.2),
      shadowColor: Colors.transparent,
      selectedShadowColor: Colors.transparent,
      checkmarkColor: primaryColorLight,
      labelStyle: const TextStyle(color: Color(0xFFE2E8F0)),
      secondaryLabelStyle: const TextStyle(color: Color(0xFFE2E8F0)),
      brightness: Brightness.dark,
      elevation: 0,
      pressElevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: const BorderSide(color: Color(0xFF334155)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF334155),
      thickness: 1,
      space: 1,
    ),
  );
}
