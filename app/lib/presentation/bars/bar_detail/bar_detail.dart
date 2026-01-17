import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:happyhour_app/application/bars/bar_detail/bar_detail_cubit.dart';
import 'package:happyhour_app/application/bars/bar_detail/bar_detail_state.dart';
import 'package:happyhour_app/domain/bars/entities/bar.dart';
import 'package:happyhour_app/gen_l10n/app_localizations.dart';
import 'package:happyhour_app/presentation/bars/bar_detail/bar_map.dart';
import 'package:happyhour_app/presentation/core/theme/theme.dart';
import 'package:happyhour_app/presentation/core/widgets/circular_bar_image.dart';

/// Screen displaying detailed information about a single bar.
/// Uses circular hero images, 24px+ radii, and gradient backgrounds
/// per design system spec.
class BarDetail extends StatelessWidget {
  const BarDetail({super.key});

  /// Calculate responsive image radius for detail view
  /// Target: 100-140px diameter = 50-70 radius
  double _getDetailRadius(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.15).clamp(50.0, 70.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<BarDetailCubit, BarDetailState>(
        builder: (context, state) {
          return switch (state) {
            BarDetailInitial() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            BarDetailLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            BarDetailError(:final message) => _buildErrorState(
              context,
              message,
            ),
            BarDetailLoaded(:final bar, :final isHappyHourActive) =>
              _buildLoadedState(context, bar, isHappyHourActive),
          };
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.msgOops,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.read<BarDetailCubit>().loadBar(),
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.actionTryAgain),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, Bar bar, bool isActive) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final imageRadius = _getDetailRadius(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            ),
            onPressed: () => context.pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Map background
                BarMap(
                  latitude: bar.latitude,
                  longitude: bar.longitude,
                  name: bar.name,
                ),
                // Gradient overlay for depth
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: Offset(0, -imageRadius * 0.6),
            child: Column(
              children: [
                // Circular hero image overlapping the header
                CircularBarImage(
                  imageUrl: bar.imageUrl,
                  radius: imageRadius,
                  isHappyHourActive: isActive,
                  heroTag: 'bar-image-${bar.id}',
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and active status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              bar.name,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      if (isActive) ...[
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: AppColors.onPrimary,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.labelHappyHour,
                                  style: AppTypography.badge.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Address - gradient card
                      _buildInfoCard(
                        context,
                        icon: Icons.location_on,
                        content: bar.street,
                      ),
                      const SizedBox(height: 12),

                      // Happy hour times - gradient card
                      _buildInfoCard(
                        context,
                        icon: Icons.access_time,
                        content:
                            '${bar.happyHourDays.displayString} • ${bar.happyHourTime.displayString}',
                      ),
                      const SizedBox(height: 24),

                      // Prices section
                      Text(
                        l10n.labelHappyHourPrices,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPriceCard(
                              context,
                              Icons.sports_bar,
                              l10n.labelBeer,
                              '${bar.cheapestBeerPrice} kr',
                              AppColors.primaryContainer,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPriceCard(
                              context,
                              Icons.wine_bar,
                              l10n.labelWine,
                              '${bar.cheapestWinePrice} kr',
                              AppColors.surfaceHigh,
                            ),
                          ),
                        ],
                      ),
                      if (bar.twoForOne) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.success.withValues(alpha: 0.15),
                                AppColors.success.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.celebration,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.labelTwoForOneAvailable,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Notes section
                      if (bar.notes.isNotEmpty) ...[
                        Text(
                          l10n.labelNotes,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: AppColors.cardGradient,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            bar.notes,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Description section
                      if (bar.description != null &&
                          bar.description!.isNotEmpty) ...[
                        Text(
                          l10n.labelAbout,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bar.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Contact
                      Text(
                        l10n.labelContact,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        context,
                        icon: Icons.email_outlined,
                        content: bar.email,
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Info card with gradient background and 24px radius
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Price card with gradient background and 24px radius
  Widget _buildPriceCard(
    BuildContext context,
    IconData icon,
    String label,
    String price,
    Color accentColor,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor,
            accentColor.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.textPrimary),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: AppTypography.price.copyWith(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
