import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constants.dart';
import 'colors.dart';
import 'typography.dart';

/// Application Theme Configuration
/// Provides Light and Dark theme configurations using centralized constants
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.blueLight,
        error: AppColors.primary,
        onSecondary: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.h2.copyWith(color: AppColors.textPrimary),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.h1.copyWith(color: AppColors.textPrimary),
        displayMedium: AppTypography.h2.copyWith(color: AppColors.textPrimary),
        displaySmall: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        headlineMedium: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        ),
        color: AppColors.surface,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMD,
          vertical: AppConstants.spacingMD,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLG,
            vertical: AppConstants.spacingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.button,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppConstants.iconSizeMD,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // /// Dark Theme Configuration
  // static ThemeData get darkTheme {
  //   return ThemeData(
  //     useMaterial3: true,
  //     brightness: Brightness.dark,
  //     primaryColor: AppColors.primary,
  //     scaffoldBackgroundColor: AppColors.backgroundDark,
  //     colorScheme: const ColorScheme.dark(
  //       primary: AppColors.primary,
  //       secondary: AppColors.blueLight,
  //       background: AppColors.backgroundDark,
  //       surface: AppColors.surfaceDark,
  //       error: AppColors.primary,
  //       onPrimary: AppColors.textOnPrimary,
  //       onSecondary: AppColors.textOnPrimary,
  //       onBackground: AppColors.textDisabled,
  //       onSurface: AppColors.textDisabled,
  //     ),

  //     // AppBar Theme
  //     appBarTheme: AppBarTheme(
  //       elevation: 0,
  //       centerTitle: true,
  //       backgroundColor: AppColors.backgroundDark,
  //       foregroundColor: AppColors.textSecondary,
  //       systemOverlayStyle: SystemUiOverlayStyle.light,
  //       titleTextStyle: AppTypography.h2.copyWith(color: AppColors.textSecondary),
  //     ),

  //     // Text Theme
  //     textTheme: TextTheme(
  //       displayLarge: AppTypography.h1.copyWith(color: AppColors.textSecondary),
  //       displayMedium: AppTypography.h2.copyWith(color: AppColors.textSecondary),
  //       displaySmall: AppTypography.h3.copyWith(color: AppColors.textSecondary),
  //       headlineMedium: AppTypography.h4.copyWith(color: AppColors.textSecondary),
  //       bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
  //       bodyMedium: AppTypography.bodyMedium.copyWith(
  //         color: AppColors.textSecondary,
  //       ),
  //       bodySmall: AppTypography.bodySmall.copyWith(
  //         color: AppColors.textSecondary,
  //       ),
  //     ),

  //     // Card Theme
  //     cardTheme: CardThemeData(
  //       elevation: 2,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(AppConstants.radiusLG),
  //       ),
  //       color: AppColors.surfaceDark,
  //     ),

  //     // Input Decoration Theme
  //     inputDecorationTheme: InputDecorationTheme(
  //       filled: true,
  //       fillColor: AppColors.surfaceDark,
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(AppConstants.radiusLG),
  //         borderSide: const BorderSide(color: AppColors.border),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(AppConstants.radiusLG),
  //         borderSide: const BorderSide(color: AppColors.border),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(AppConstants.radiusLG),
  //         borderSide: const BorderSide(color: AppColors.primary, width: 2),
  //       ),
  //       errorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(AppConstants.radiusLG),
  //         borderSide: const BorderSide(color: AppColors.primary),
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(
  //         horizontal: AppConstants.spacingMD,
  //         vertical: AppConstants.spacingMD,
  //       ),
  //     ),

  //     // Elevated Button Theme
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: AppColors.primary,
  //         foregroundColor: AppColors.textOnPrimary,
  //         elevation: 2,
  //         padding: const EdgeInsets.symmetric(
  //           horizontal: AppConstants.spacingLG,
  //           vertical: AppConstants.spacingMD,
  //         ),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(AppConstants.radiusLG),
  //         ),
  //         textStyle: AppTypography.button,
  //       ),
  //     ),

  //     // Text Button Theme
  //     textButtonTheme: TextButtonThemeData(
  //       style: TextButton.styleFrom(
  //         foregroundColor: AppColors.primary,
  //         textStyle: AppTypography.button,
  //       ),
  //     ),

  //     // Icon Theme
  //     iconTheme: const IconThemeData(
  //       color: AppColors.textSecondary,
  //       size: AppConstants.iconSizeMD,
  //     ),

  //     // Divider Theme
  //     dividerTheme: const DividerThemeData(
  //       color: AppColors.border,
  //       thickness: 1,
  //       space: 1,
  //     ),
  //   );
  // }
}
