import 'package:flutter/material.dart';
import 'package:happyhour_app/domain/bars/enums/sort_preference.dart';
import 'package:happyhour_app/gen_l10n/app_localizations.dart';

/// A dropdown widget for selecting sort preference.
class SortDropdown extends StatelessWidget {
  final SortPreference selectedSort;
  final ValueChanged<SortPreference> onSortChanged;
  final bool showDistanceOption;
  final bool showRatingOption;

  const SortDropdown({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
    this.showDistanceOption = false,
    this.showRatingOption = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<SortPreference>(
      initialValue: selectedSort,
      onSelected: onSortChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sort,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              _getSortLabel(context, selectedSort),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        final l10n = AppLocalizations.of(context);
        return [
          _buildMenuItem(
            context,
            SortPreference.serverOrder,
            l10n.sortDefault,
            Icons.reorder,
          ),
          _buildMenuItem(
            context,
            SortPreference.beerPrice,
            l10n.sortCheapestBeer,
            Icons.sports_bar,
          ),
          if (showDistanceOption)
            _buildMenuItem(
              context,
              SortPreference.distance,
              l10n.sortNearest,
              Icons.near_me,
            ),
          if (showRatingOption)
            _buildMenuItem(
              context,
              SortPreference.rating,
              l10n.sortTopRated,
              Icons.star,
            ),
        ];
      },
    );
  }

  PopupMenuItem<SortPreference> _buildMenuItem(
    BuildContext context,
    SortPreference value,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = selectedSort == value;

    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(
              Icons.check,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ],
        ],
      ),
    );
  }

  String _getSortLabel(BuildContext context, SortPreference sort) {
    final l10n = AppLocalizations.of(context);
    return switch (sort) {
      SortPreference.serverOrder => l10n.sortDefault,
      SortPreference.beerPrice => l10n.sortLabelPrice,
      SortPreference.distance => l10n.sortLabelDistance,
      SortPreference.rating => l10n.sortLabelRating,
    };
  }
}
