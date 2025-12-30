import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF0D0D0D);
  static const backgroundGradientEnd = Color(0xFF1A1A1A);
  static const surface = Color(0xFF1E1E1E);
  static const surfaceVariant = Color(0xFF2A2020);
  static const surfaceHigh = Color(0xFF2D2D2D);
  static const primary = Color(0xFFC62828);
  static const primaryLight = Color(0xFFE53935);
  static const secondary = Color(0xFFFF5252);
  static const primaryContainer = Color(0xFF4A1C1C);
  static const onPrimaryContainer = Color(0xFFFFDAD4);
  static const success = Color(0xFF4CAF50);
  static const successContainer = Color(0xFF1B3D1E);
  static const warning = Color(0xFFFFB74D);
  static const warningContainer = Color(0xFF3D3019);
  static const error = Color(0xFFEF5350);
  static const errorContainer = Color(0xFF4A1C1C);
  static const onErrorContainer = Color(0xFFFFDAD4);
  static const textPrimary = Color(0xFFFAFAFA);
  static const textSecondary = Color(0xFFB0B0B0);
  static const textTertiary = Color(0xFF757575);
  static const onPrimary = Color(0xFFFFFFFF);
  static const divider = Color(0xFF3D3D3D);
  static const shimmerBase = Color(0xFF2A2A2A);
  static const shimmerHighlight = Color(0xFF3D3D3D);
  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, surfaceVariant],
  );
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, backgroundGradientEnd],
  );
  static const activeGlowGradient = RadialGradient(
    colors: [Color(0x40C62828), Colors.transparent],
  );
}
