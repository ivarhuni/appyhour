import 'package:flutter/material.dart';
import 'package:happyhour_app/presentation/core/theme/brand_colors.dart';

/// Grapevine "Appy Hour" brand color palette (teal/orange editorial theme).
///
/// Implements [BrandColors] with a sophisticated magazine aesthetic
/// inspired by grapevine.is - teal primary with orange accents.
class GrapevineColors implements BrandColors {
  const GrapevineColors();

  // Background colors
  @override
  Color get background => const Color(0xFF1A1A1A);
  @override
  Color get backgroundGradientEnd => const Color(0xFF2D2D2D);

  // Surface colors
  @override
  Color get surface => const Color(0xFF252525);
  @override
  Color get surfaceVariant => const Color(0xFF2A2A2A);
  @override
  Color get surfaceHigh => const Color(0xFF333333);

  // Primary accent (teal)
  @override
  Color get primary => const Color(0xFF0D9488);
  @override
  Color get primaryLight => const Color(0xFF14B8A6);
  @override
  Color get primaryContainer => const Color(0xFF134E4A);
  @override
  Color get onPrimaryContainer => const Color(0xFFCCFBF1);

  // Secondary accent (orange)
  @override
  Color get secondary => const Color(0xFFE64A19);

  // Semantic colors
  @override
  Color get success => const Color(0xFF10B981);
  @override
  Color get successContainer => const Color(0xFF064E3B);
  @override
  Color get warning => const Color(0xFFF59E0B);
  @override
  Color get warningContainer => const Color(0xFF78350F);
  @override
  Color get error => const Color(0xFFEF4444);
  @override
  Color get errorContainer => const Color(0xFF7F1D1D);
  @override
  Color get onErrorContainer => const Color(0xFFFECACA);

  // Text colors
  @override
  Color get textPrimary => const Color(0xFFFFFFFF);
  @override
  Color get textSecondary => const Color(0xFFA3A3A3);
  @override
  Color get textTertiary => const Color(0xFF737373);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  // Utility colors
  @override
  Color get divider => const Color(0xFF404040);
  @override
  Color get shimmerBase => const Color(0xFF2A2A2A);
  @override
  Color get shimmerHighlight => const Color(0xFF404040);

  // Gradients
  @override
  Gradient get cardGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, surfaceVariant],
  );

  @override
  Gradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, backgroundGradientEnd],
  );

  @override
  Gradient get activeGlowGradient => RadialGradient(
    colors: [primary.withValues(alpha: 0.25), Colors.transparent],
  );
}
