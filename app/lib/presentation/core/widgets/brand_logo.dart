import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happyhour_app/presentation/core/brand/brand.dart';

/// A widget that displays the brand logo or app name text.
///
/// For brands with a logo asset (like Grapevine), displays the SVG logo.
/// For brands without a logo (like the default theme), displays the app name.
class BrandLogo extends StatelessWidget {
  /// The height of the logo/text. Defaults to 32.
  final double height;

  /// Optional color filter to apply to SVG logos.
  /// If null, the logo's original colors are used.
  final Color? colorFilter;

  const BrandLogo({
    super.key,
    this.height = 32,
    this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    final brand = BrandProvider.of(context);

    if (brand.hasLogo) {
      return _buildSvgLogo(brand);
    } else {
      return _buildTextLogo(brand);
    }
  }

  Widget _buildSvgLogo(BrandConfig brand) {
    return SvgPicture.asset(
      brand.logoAsset!,
      height: height,
      colorFilter: colorFilter != null
          ? ColorFilter.mode(colorFilter!, BlendMode.srcIn)
          : null,
    );
  }

  Widget _buildTextLogo(BrandConfig brand) {
    return Text(
      brand.appName,
      style: brand.typography.barName.copyWith(
        fontSize: height * 0.7,
      ),
    );
  }
}

/// A responsive brand logo that adapts to screen width.
class ResponsiveBrandLogo extends StatelessWidget {
  /// Minimum logo height
  final double minHeight;

  /// Maximum logo height
  final double maxHeight;

  /// Optional color filter to apply to SVG logos.
  final Color? colorFilter;

  const ResponsiveBrandLogo({
    super.key,
    this.minHeight = 24,
    this.maxHeight = 40,
    this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    // Scale logo with screen width, clamped to min/max
    final logoHeight = (width * 0.08).clamp(minHeight, maxHeight);

    return BrandLogo(
      height: logoHeight,
      colorFilter: colorFilter,
    );
  }
}
