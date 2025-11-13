import 'package:flutter/material.dart';

class AppColors {
  static const cherryPink = Color(0xFFF89CAB);
  static const softSky = Color(0xFFE9F7FF);
  static const rose = Color(0xFFF297A0);
  static const blush = Color(0xFFF9D0CE);
  static const oliveMist = Color(0xFFB6BB79);
  static const creamy = Color(0xFFF3EBD8);

  // netral teks
  static const textDark = Color(0xFF2D2A2A);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.rose,
      background: AppColors.softSky,
      primary: AppColors.rose,
      secondary: AppColors.oliveMist,
      tertiary: AppColors.blush,
      surface: AppColors.creamy,
      onPrimary: Colors.white,
      onSecondary: AppColors.textDark,
      onTertiary: AppColors.textDark,
      onSurface: AppColors.textDark,
      onBackground: AppColors.textDark,
      brightness: Brightness.light,
    ),
    fontFamily: 'Roboto',
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.creamy,
      foregroundColor: AppColors.textDark,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.rose,
      unselectedItemColor: Colors.grey,
      backgroundColor: AppColors.creamy,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardTheme(
      color: AppColors.creamy,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppColors.blush,
      labelStyle: TextStyle(color: AppColors.textDark),
    ),
  );
}
