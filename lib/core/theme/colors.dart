import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ========== Brand / Primary ==========
  static const Color primary = Color(0xFFEE3355);
  static const Color primaryHover = Color(0xFFFCE0E6);

  // ========== Neutrals ==========
  static const Color black = Color(0xFF000000);
  static const Color mainBlack = Color(0xFF1A1A1A);

  static const Color white = Color(0xFFFFFFFF);
  static const Color white10 = Color(0x1AFFFFFF); // 10% opacity

  // ========== Greys ==========
  static const Color greyNormal = Color(0xFF1C1C1E);
  static const Color greyMain = Color(0xFF6E6E6E);
  static const Color greyDark = Color(0xFF373737);
  static const Color greyMedium = Color(0xFF757575);
  static const Color greyLight = Color(0xFFC4C4C4);
  static const Color greyUltraLight = Color(0xFFFAFAFA);
  static const Color greyBackground = Color(0xFFF5F5F5);

  // ========== Supporting ==========
  static const Color blueLight = Color(0xFFE7E8E9);

  // ========== Semantic ==========
  static const Color background = white;
  static const Color backgroundDark = greyNormal;

  static const Color surface = white;
  static const Color surfaceDark = Color(0xFF1A1A1A);

  static const Color textPrimary = mainBlack;
  static const Color textSecondary = greyMedium;
  static const Color textDisabled = greyLight;
  static const Color textOnPrimary = white;

  static const Color border = greyLight;
  static const Color divider = greyUltraLight;

  // ========== Feedback ==========
  static const Color success = Color(0xFF19CF10);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color amber = Color(0xFFFFC107);

  // ========== Shimmer ==========
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
