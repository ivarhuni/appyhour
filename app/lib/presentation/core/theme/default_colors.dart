import 'package:flutter/material.dart';
import 'package:happyhour_app/presentation/core/theme/brand_colors.dart';

/// Default "Happy Hour" brand color palette (dark-red theme).
///
/// Implements [BrandColors] to provide the original app color scheme.
class DefaultColors implements BrandColors {
  const DefaultColors();

  // Background colors
  @override
  Color get background => const Color(0xFF0D0D0D);
  @override
  Color get backgroundGradientEnd => const Color(0xFF1A1A1A);

  // Surface colors
  @override
  Color get surface => const Color(0xFF1E1E1E);
  @override
  Color get surfaceVariant => const Color(0xFF2A2020);
  @override
  Color get surfaceHigh => const Color(0xFF2D2D2D);

  // Primary accent (red)
  @override
  Color get primary => const Color(0xFFC62828);
  @override
  Color get primaryLight => const Color(0xFFE53935);
  @override
  Color get primaryContainer => const Color(0xFF4A1C1C);
  @override
  Color get onPrimaryContainer => const Color(0xFFFFDAD4);

  // Secondary accent
  @override
  Color get secondary => const Color(0xFFFF5252);

  // Semantic colors
  @override
  Color get success => const Color(0xFF4CAF50);
  @override
  Color get successContainer => const Color(0xFF1B3D1E);
  @override
  Color get warning => const Color(0xFFFFB74D);
  @override
  Color get warningContainer => const Color(0xFF3D3019);
  @override
  Color get error => const Color(0xFFEF5350);
  @override
  Color get errorContainer => const Color(0xFF4A1C1C);
  @override
  Color get onErrorContainer => const Color(0xFFFFDAD4);

  // Text colors
  @override
  Color get textPrimary => const Color(0xFFFAFAFA);
  @override
  Color get textSecondary => const Color(0xFFB0B0B0);
  @override
  Color get textTertiary => const Color(0xFF757575);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  // Utility colors
  @override
  Color get divider => const Color(0xFF3D3D3D);
  @override
  Color get shimmerBase => const Color(0xFF2A2A2A);
  @override
  Color get shimmerHighlight => const Color(0xFF3D3D3D);

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
