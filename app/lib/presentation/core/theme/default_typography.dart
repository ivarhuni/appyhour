import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happyhour_app/presentation/core/theme/brand_colors.dart';
import 'package:happyhour_app/presentation/core/theme/brand_typography.dart';
import 'package:happyhour_app/presentation/core/theme/default_colors.dart';

/// Default "Happy Hour" brand typography (Playfair Display + Plus Jakarta Sans).
///
/// Implements [BrandTypography] to provide the original app typography scheme.
class DefaultTypography implements BrandTypography {
  final BrandColors _colors;

  const DefaultTypography([this._colors = const DefaultColors()]);

  @override
  TextStyle get displayFont => GoogleFonts.playfairDisplay();

  @override
  TextStyle get bodyFont => GoogleFonts.plusJakartaSans();

  @override
  TextStyle get monoFont => GoogleFonts.firaCode();

  @override
  TextTheme get textTheme {
    final baseTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme,
    );
    return baseTheme.copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: _colors.textPrimary,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: _colors.textPrimary,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: _colors.textPrimary,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: _colors.textSecondary,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: _colors.textSecondary,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
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
  TextStyle get barName => GoogleFonts.playfairDisplay(
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
  TextStyle get chip => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: _colors.textPrimary,
  );

  @override
  TextStyle get badge => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: _colors.onPrimary,
  );
}
