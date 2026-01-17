import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happyhour_app/presentation/core/theme/brand_colors.dart';
import 'package:happyhour_app/presentation/core/theme/brand_typography.dart';
import 'package:happyhour_app/presentation/core/theme/grapevine_colors.dart';

/// Grapevine "Appy Hour" brand typography (Lora + Source Sans 3).
///
/// Implements [BrandTypography] with an editorial magazine aesthetic.
/// Lora provides elegant serif headlines, Source Sans 3 clean body text.
class GrapevineTypography implements BrandTypography {
  final BrandColors _colors;

  const GrapevineTypography([this._colors = const GrapevineColors()]);

  @override
  TextStyle get displayFont => GoogleFonts.lora();

  @override
  TextStyle get bodyFont => GoogleFonts.sourceSans3();

  @override
  TextStyle get monoFont => GoogleFonts.firaCode();

  @override
  TextTheme get textTheme {
    final baseTheme = GoogleFonts.sourceSans3TextTheme(
      ThemeData.dark().textTheme,
    );
    return baseTheme.copyWith(
      displayLarge: GoogleFonts.lora(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: _colors.textPrimary,
      ),
      displayMedium: GoogleFonts.lora(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      displaySmall: GoogleFonts.lora(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      headlineLarge: GoogleFonts.lora(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      headlineMedium: GoogleFonts.lora(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      headlineSmall: GoogleFonts.lora(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      titleLarge: GoogleFonts.sourceSans3(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      titleMedium: GoogleFonts.sourceSans3(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: _colors.textPrimary,
      ),
      titleSmall: GoogleFonts.sourceSans3(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: _colors.textPrimary,
      ),
      bodyLarge: GoogleFonts.sourceSans3(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: _colors.textSecondary,
      ),
      bodyMedium: GoogleFonts.sourceSans3(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: _colors.textSecondary,
      ),
      bodySmall: GoogleFonts.sourceSans3(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: _colors.textTertiary,
      ),
      labelLarge: GoogleFonts.firaCode(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: _colors.textPrimary,
      ),
      labelMedium: GoogleFonts.firaCode(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: _colors.textPrimary,
      ),
      labelSmall: GoogleFonts.firaCode(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: _colors.textSecondary,
      ),
    );
  }

  @override
  TextStyle get barName => GoogleFonts.lora(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: _colors.textPrimary,
  );

  @override
  TextStyle get price => GoogleFonts.firaCode(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: _colors.textPrimary,
  );

  @override
  TextStyle get data => GoogleFonts.firaCode(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: _colors.textSecondary,
  );

  @override
  TextStyle get chip => GoogleFonts.sourceSans3(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: _colors.textPrimary,
  );

  @override
  TextStyle get badge => GoogleFonts.sourceSans3(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: _colors.onPrimary,
  );
}
