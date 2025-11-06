// core/theme.dart

import 'package:flutter/material.dart';

/// App-wide theme configuration
///
/// Centralizes all colors, text styles, and theme data.
/// This ensures consistency across the app and makes it easy to update the design.

class AppTheme {
  // ============ COLOR PALETTE ============

  /// Main app color (pink/purple - used for home screen)
  static const Color PRIMARY_COLOR = Color.fromARGB(255, 236, 199, 231);

  /// Activity screen color (blue)
  static const Color ACTIVITY_COLOR = Color.fromARGB(255, 64, 155, 197);
  static const Color ACTIVITY_CONTAINER_COLOR = Color.fromARGB(255, 130, 167, 197);

  /// Health screen color (green)
  static const Color HEALTH_COLOR = Color.fromARGB(255, 141, 227, 138);
  static const Color HEALTH_CONTAINER_COLOR = Color.fromARGB(255, 34, 169, 88);

  /// Cycle screen color (pink)
  static const Color CYCLE_COLOR = Color.fromARGB(255, 236, 161, 202);
  static const Color CYCLE_CONTAINER_COLOR = Color.fromARGB(255, 252, 212, 232);

  /// AppBar background color
  static const Color APPBAR_BACKGROUND = Color.fromARGB(255, 232, 226, 218);

  /// Chart colors
  static const Color CHART_BAR_COLOR = Color(0xFF90A7C5); // blueGrey[400]
  static const Color CHART_BACKGROUND_COLOR = Color(0xFFE0E0E0); // grey[300]
  static const Color HRV_CHART_COLOR = Color.fromARGB(255, 15, 214, 197);

  /// Text colors
  static const Color TEXT_PRIMARY = Colors.black;
  static const Color TEXT_SECONDARY = Colors.white;

  // ============ THEME DATA ============

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: PRIMARY_COLOR,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PRIMARY_COLOR,
        brightness: Brightness.light,
      ),

      /// AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: APPBAR_BACKGROUND,
        foregroundColor: TEXT_PRIMARY,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: TEXT_PRIMARY,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),

      /// Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          foregroundColor: TEXT_PRIMARY,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),

      /// Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: TEXT_PRIMARY,
        ),
        headlineMedium: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w600,
          color: TEXT_PRIMARY,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: TEXT_PRIMARY,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: TEXT_PRIMARY,
        ),
      ),
    );
  }
}
