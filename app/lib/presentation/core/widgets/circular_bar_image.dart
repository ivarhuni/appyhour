import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:happyhour_app/presentation/core/theme/theme.dart';

class CircularBarImage extends StatefulWidget {
  final String? imageUrl;
  final double radius;
  final bool isHappyHourActive;
  final String? heroTag;
  final IconData placeholderIcon;

  const CircularBarImage({
    super.key,
    this.imageUrl,
    this.radius = 32,
    this.isHappyHourActive = false,
    this.heroTag,
    this.placeholderIcon = Icons.sports_bar,
  });

  @override
  State<CircularBarImage> createState() => _CircularBarImageState();
}

class _CircularBarImageState extends State<CircularBarImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.isHappyHourActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CircularBarImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHappyHourActive != oldWidget.isHappyHourActive) {
      if (widget.isHappyHourActive) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final glowIntensity = widget.isHappyHourActive
            ? 0.3 + (_pulseAnimation.value * 0.2)
            : 0.0;
        final glowSpread = widget.isHappyHourActive
            ? 2 + (_pulseAnimation.value * 4)
            : 0.0;
        final glowBlur = widget.isHappyHourActive
            ? 12 + (_pulseAnimation.value * 8)
            : 8.0;
        return Container(
          width: widget.radius * 2,
          height: widget.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              if (widget.isHappyHourActive)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: glowIntensity),
                  blurRadius: glowBlur,
                  spreadRadius: glowSpread,
                ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        );
      },
      child: _buildImage(),
    );
    if (widget.heroTag != null) {
      imageWidget = Hero(tag: widget.heroTag!, child: imageWidget);
    }
    return imageWidget;
  }

  Widget _buildImage() {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl!,
        width: widget.radius * 2,
        height: widget.radius * 2,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(showLoader: true),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder({bool showLoader = false}) {
    return Container(
      width: widget.radius * 2,
      height: widget.radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surfaceVariant, AppColors.surface],
        ),
        border: Border.all(
          color: widget.isHappyHourActive
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.divider,
          width: widget.isHappyHourActive ? 2 : 1,
        ),
      ),
      child: Center(
        child: showLoader
            ? SizedBox(
                width: widget.radius * 0.6,
                height: widget.radius * 0.6,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : Icon(
                widget.placeholderIcon,
                size: widget.radius * 0.8,
                color: widget.isHappyHourActive
                    ? AppColors.primary
                    : AppColors.textTertiary,
              ),
      ),
    );
  }
}
