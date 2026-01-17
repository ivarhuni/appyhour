import 'package:flutter/material.dart';
import 'package:happyhour_app/domain/bars/entities/bar.dart';
import 'package:happyhour_app/gen_l10n/app_localizations.dart';
import 'package:happyhour_app/presentation/core/brand/brand.dart';
import 'package:happyhour_app/presentation/core/widgets/animated_card.dart';
import 'package:happyhour_app/presentation/core/widgets/circular_bar_image.dart';

/// A list item widget displaying bar summary information.
/// Uses AnimatedCard with gradient background, CircularBarImage with glow,
/// and stadium-shaped price chips per design system spec.
class BarListItem extends StatefulWidget {
  final Bar bar;
  final VoidCallback? onTap;
  final int index;

  const BarListItem({
    super.key,
    required this.bar,
    this.onTap,
    this.index = 0,
  });

  @override
  State<BarListItem> createState() => _BarListItemState();
}

class _BarListItemState extends State<BarListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.of(context).disableAnimations;

    if (_fadeController.status == AnimationStatus.dismissed) {
      if (_reduceMotion) {
        // Skip animation, show immediately
        _fadeController.value = 1.0;
      } else {
        // Stagger: delay based on index
        Future.delayed(Duration(milliseconds: widget.index * 60), () {
          if (mounted) _fadeController.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  /// Calculate responsive image radius based on screen width
  /// Target: 56-72px diameter = 28-36 radius
  double _getResponsiveRadius(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.08).clamp(28.0, 36.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = BrandProvider.of(context);
    final colors = brand.colors;
    final typography = brand.typography;
    final l10n = AppLocalizations.of(context);
    final isActive = widget.bar.isHappyHourActive();
    final radius = _getResponsiveRadius(context);

    final Widget content = AnimatedCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      isActive: isActive,
      onTap: widget.onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular bar image with hero transition
          CircularBarImage(
            imageUrl: widget.bar.imageUrl,
            radius: radius,
            isHappyHourActive: isActive,
            heroTag: 'bar-image-${widget.bar.id}',
          ),
          const SizedBox(width: 16),
          // Bar info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and active status row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.bar.name,
                        style: typography.barName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          l10n.labelHappyHour,
                          style: typography.badge,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                // Address row
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: colors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.bar.street,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Price chips row
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildPriceChip(
                      context,
                      Icons.sports_bar,
                      '${widget.bar.cheapestBeerPrice} kr',
                      colors.primaryContainer,
                    ),
                    _buildPriceChip(
                      context,
                      Icons.wine_bar,
                      '${widget.bar.cheapestWinePrice} kr',
                      colors.surfaceHigh,
                    ),
                    if (widget.bar.twoForOne)
                      _buildSpecialChip(
                        context,
                        l10n.labelTwoForOne,
                        colors.success,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // Time and distance row
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: colors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${widget.bar.happyHourDays.displayString} • ${widget.bar.happyHourTime.displayString}',
                        style: typography.data.copyWith(
                          color: colors.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.bar.distanceFromUser != null) ...[
                      Icon(
                        Icons.directions_walk,
                        size: 14,
                        color: colors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDistance(widget.bar.distanceFromUser!),
                        style: typography.data.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Wrap with staggered entrance animation
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: content,
      ),
    );
  }

  /// Stadium-shaped price chip (FR-006)
  Widget _buildPriceChip(
    BuildContext context,
    IconData icon,
    String label,
    Color backgroundColor,
  ) {
    final brand = BrandProvider.of(context);
    final colors = brand.colors;
    final typography = brand.typography;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999), // Stadium shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.textPrimary),
          const SizedBox(width: 4),
          Text(label, style: typography.chip),
        ],
      ),
    );
  }

  /// Special badge chip for 2-for-1 deals
  Widget _buildSpecialChip(
    BuildContext context,
    String label,
    Color backgroundColor,
  ) {
    final typography = BrandProvider.of(context).typography;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: backgroundColor.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        label,
        style: typography.chip.copyWith(color: backgroundColor),
      ),
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }
}
