import 'package:flutter/material.dart';
import 'package:happyhour_app/presentation/core/theme/theme.dart';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final bool asymmetricCorners;
  final bool isActive;
  final VoidCallback? onTap;
  final bool showTapFeedback;
  final Gradient? gradient;

  const AnimatedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 24,
    this.asymmetricCorners = false,
    this.isActive = false,
    this.onTap,
    this.showTapFeedback = true,
    this.gradient,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.showTapFeedback && widget.onTap != null)
      _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.showTapFeedback) _scaleController.reverse();
  }

  void _handleTapCancel() {
    if (widget.showTapFeedback) _scaleController.reverse();
  }

  BorderRadius get _borderRadius {
    if (widget.asymmetricCorners) {
      return BorderRadius.only(
        topLeft: Radius.circular(widget.borderRadius * 1.33),
        topRight: Radius.circular(widget.borderRadius * 0.33),
        bottomLeft: Radius.circular(widget.borderRadius * 0.33),
        bottomRight: Radius.circular(widget.borderRadius * 1.33),
      );
    }
    return BorderRadius.circular(widget.borderRadius);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: Container(
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            gradient: widget.gradient ?? AppColors.cardGradient,
            border: widget.isActive
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            boxShadow: [
              if (widget.isActive)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: _borderRadius,
            child: Material(
              color: Colors.transparent,
              child: Padding(padding: widget.padding, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
