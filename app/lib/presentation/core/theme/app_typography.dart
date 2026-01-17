import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happyhour_app/presentation/core/theme/app_colors.dart';

abstract final class AppTypography {
  static TextStyle get displayFont => GoogleFonts.playfairDisplay();
  static TextStyle get bodyFont => GoogleFonts.plusJakartaSans();
  static TextStyle get monoFont => GoogleFonts.firaCode();

  static TextTheme get textTheme {
    final baseTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme,
    );
    return baseTheme.copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.textTertiary,
      ),
      labelLarge: GoogleFonts.firaCode(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.firaCode(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
      ),
      labelSmall: GoogleFonts.firaCode(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      ),
    );
  }

  static TextStyle get barName => GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle get price => GoogleFonts.firaCode(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle get data => GoogleFonts.firaCode(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static TextStyle get chip => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle get badge => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.onPrimary,
  );
}
