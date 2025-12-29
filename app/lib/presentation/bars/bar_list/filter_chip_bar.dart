import 'package:flutter/material.dart';
import 'package:happyhour_app/domain/bars/enums/filter_mode.dart';
import 'package:happyhour_app/gen_l10n/app_localizations.dart';

/// A filter chip bar for toggling between ALL and ONGOING filter modes.
class FilterChipBar extends StatelessWidget {
  final FilterMode selectedMode;
  final ValueChanged<FilterMode> onFilterChanged;

  const FilterChipBar({
    super.key,
    required this.selectedMode,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildChip(
            context,
            label: l10n.filterAll,
            icon: Icons.list,
            isSelected: selectedMode == FilterMode.all,
            onTap: () => onFilterChanged(FilterMode.all),
          ),
          const SizedBox(width: 8),
          _buildChip(
            context,
            label: l10n.filterHappyHourNow,
            icon: Icons.local_fire_department,
            isSelected: selectedMode == FilterMode.ongoing,
            onTap: () => onFilterChanged(FilterMode.ongoing),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: theme.colorScheme.primary,
      checkmarkColor: theme.colorScheme.onPrimary,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
