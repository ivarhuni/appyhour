import 'package:flutter/foundation.dart';
import 'package:happyhour_app/presentation/core/brand/app_brand.dart';
import 'package:happyhour_app/presentation/core/theme/brand_colors.dart';
import 'package:happyhour_app/presentation/core/theme/brand_typography.dart';
import 'package:happyhour_app/presentation/core/theme/default_colors.dart';
import 'package:happyhour_app/presentation/core/theme/default_typography.dart';
import 'package:happyhour_app/presentation/core/theme/grapevine_colors.dart';
import 'package:happyhour_app/presentation/core/theme/grapevine_typography.dart';

/// Immutable configuration for a brand variant.
///
/// Provides all customization points for theming including colors,
/// typography, logo, and app display name.
@immutable
class BrandConfig {
  /// The brand identifier
  final AppBrand brand;

  /// Display name shown in UI (e.g., "Happy Hour", "Appy Hour")
  final String appName;

  /// Asset path for brand logo, null for text-only branding
  final String? logoAsset;

  /// Color palette for this brand
  final BrandColors colors;

  /// Typography scheme for this brand
  final BrandTypography typography;

  const BrandConfig({
    required this.brand,
    required this.appName,
    this.logoAsset,
    required this.colors,
    required this.typography,
  });

  /// Whether this brand has a logo asset
  bool get hasLogo => logoAsset != null;

  /// Returns configuration for the specified brand.
  ///
  /// If an unexpected value is passed, returns [defaultBrand] as fallback (FR-009).
  static BrandConfig forBrand(AppBrand? brand) {
    if (brand == null) return _defaultConfig;

    return switch (brand) {
      AppBrand.defaultBrand => _defaultConfig,
      AppBrand.grapevine => _grapevineConfig,
    };
  }

  // Pre-built configurations for each brand
  static const _defaultColors = DefaultColors();
  static const _defaultTypography = DefaultTypography();

  static const _grapevineColors = GrapevineColors();
  static const _grapevineTypography = GrapevineTypography();

  static const _defaultConfig = BrandConfig(
    brand: AppBrand.defaultBrand,
    appName: 'Happy Hour',
    colors: _defaultColors,
    typography: _defaultTypography,
  );

  static const _grapevineConfig = BrandConfig(
    brand: AppBrand.grapevine,
    appName: 'Appy Hour',
    logoAsset: 'assets/images/grapevine_logo.svg',
    colors: _grapevineColors,
    typography: _grapevineTypography,
  );
}
