import 'package:flutter/material.dart';

class ThemeUtils {
  /// Creates a consistent TextTheme with all inherit values set to false
  /// This prevents the TextStyle interpolation error
  static TextTheme createConsistentTextTheme({
    required TextTheme baseTheme,
    required Color bodyColor,
    required Color displayColor,
    String? fontFamily,
  }) {
    return TextTheme(
      displayLarge: baseTheme.displayLarge?.copyWith(
        inherit: false,
        color: displayColor,
        fontFamily: fontFamily,
      ),
      displayMedium: baseTheme.displayMedium?.copyWith(
        inherit: false,
        color: displayColor,
        fontFamily: fontFamily,
      ),
      displaySmall: baseTheme.displaySmall?.copyWith(
        inherit: false,
        color: displayColor,
        fontFamily: fontFamily,
      ),
      headlineLarge: baseTheme.headlineLarge?.copyWith(
        inherit: false,
        color: displayColor,
        fontFamily: fontFamily,
      ),
      headlineMedium: baseTheme.headlineMedium?.copyWith(
        inherit: false,
        color: displayColor,
        fontFamily: fontFamily,
      ),
      headlineSmall: baseTheme.headlineSmall?.copyWith(
        inherit: false,
        color: displayColor,
        fontFamily: fontFamily,
      ),
      titleLarge: baseTheme.titleLarge?.copyWith(
        inherit: false,
        color: bodyColor,
        fontFamily: fontFamily,
      ),
      titleMedium: baseTheme.titleMedium?.copyWith(
        inherit: false,
        color: bodyColor,
        fontFamily: fontFamily,
      ),
      titleSmall: baseTheme.titleSmall?.copyWith(
        inherit: false,
        color: bodyColor,
        fontFamily: fontFamily,
      ),
      bodyLarge: baseTheme.bodyLarge?.copyWith(
        inherit: false,
        color: bodyColor,
        fontFamily: fontFamily,
      ),
      bodyMedium: baseTheme.bodyMedium?.copyWith(
        inherit: false,
        color: bodyColor,
        fontFamily: fontFamily,
      ),
      bodySmall: baseTheme.bodySmall?.copyWith(
        inherit: false,
        color: bodyColor,
        fontFamily: fontFamily,
      ),
      labelLarge: baseTheme.labelLarge?.copyWith(
        inherit: false,
        color: bodyColor,
        fontFamily: fontFamily,
      ),
      labelMedium: baseTheme.labelMedium?.copyWith(
        inherit: false,
        color: bodyColor,
        fontFamily: fontFamily,
      ),
      labelSmall: baseTheme.labelSmall?.copyWith(
        inherit: false,
        color: bodyColor,
        fontFamily: fontFamily,
      ),
    );
  }

  /// Validates that all TextStyles in a TextTheme have the same inherit value
  static bool validateTextThemeConsistency(TextTheme textTheme) {
    final styles = [
      textTheme.displayLarge,
      textTheme.displayMedium,
      textTheme.displaySmall,
      textTheme.headlineLarge,
      textTheme.headlineMedium,
      textTheme.headlineSmall,
      textTheme.titleLarge,
      textTheme.titleMedium,
      textTheme.titleSmall,
      textTheme.bodyLarge,
      textTheme.bodyMedium,
      textTheme.bodySmall,
      textTheme.labelLarge,
      textTheme.labelMedium,
      textTheme.labelSmall,
    ];

    bool? expectedInherit;
    for (final style in styles) {
      if (style != null) {
        if (expectedInherit == null) {
          expectedInherit = style.inherit;
        } else if (style.inherit != expectedInherit) {
          return false; // Inconsistent inherit values
        }
      }
    }
    return false;
  }
}