import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:happyhour_app/domain/value_objects/filter_mode.dart';
import 'package:happyhour_app/domain/value_objects/sort_preference.dart';
import 'package:happyhour_app/infrastructure/services/location_service.dart';
import 'package:happyhour_app/presentation/cubits/bars_list/bars_list_cubit.dart';
import 'package:happyhour_app/presentation/cubits/bars_list/bars_list_state.dart';
import 'package:happyhour_app/presentation/widgets/bar_list_item.dart';
import 'package:happyhour_app/presentation/widgets/error_banner.dart';
import 'package:happyhour_app/presentation/widgets/filter_chip_bar.dart';
import 'package:happyhour_app/presentation/widgets/sort_dropdown.dart';

/// Main screen displaying a scrollable list of bars.
class BarsListScreen extends StatefulWidget {
  const BarsListScreen({super.key});

  @override
  State<BarsListScreen> createState() => _BarsListScreenState();
}

class _BarsListScreenState extends State<BarsListScreen> {
  final LocationService _locationService = LocationService();
  bool _locationRequested = false;
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    context.read<BarsListCubit>().loadBars();
  }

  Future<void> _requestLocation() async {
    if (_locationRequested) return;

    setState(() {
      _locationRequested = true;
    });

    final status = await _locationService.checkPermission();
    if (status == LocationPermissionStatus.granted) {
      setState(() {
        _hasLocationPermission = true;
      });
      await _updateBarsWithLocation();
    }
  }

  Future<void> _updateBarsWithLocation() async {
    final position = await _locationService.getCurrentPosition();
    if (position == null || !mounted) return;

    final cubit = context.read<BarsListCubit>();
    final state = cubit.state;
    if (state is BarsListLoaded) {
      final barsWithDistance = _locationService.updateBarsWithDistance(
        state.bars,
        position,
      );
      cubit.updateBarsWithDistance(barsWithDistance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Happy Hour'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          if (!_hasLocationPermission)
            IconButton(
              icon: const Icon(Icons.location_off),
              tooltip: 'Enable location',
              onPressed: _requestLocation,
            )
          else
            IconButton(
              icon: const Icon(Icons.location_on),
              tooltip: 'Location enabled',
              onPressed: _updateBarsWithLocation,
            ),
        ],
      ),
      body: BlocBuilder<BarsListCubit, BarsListState>(
        builder: (context, state) {
          return switch (state) {
            BarsListInitial() => const Center(
              child: CircularProgressIndicator(),
            ),
            BarsListLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            BarsListError(:final message) => _buildErrorState(context, message),
            BarsListLoaded() => _buildLoadedState(context, state),
          };
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<BarsListCubit>().loadBars(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, BarsListLoaded state) {
    final hasDistanceData = state.bars.any(
      (bar) => bar.distanceFromUser != null,
    );
    final hasRatingData = state.bars.any((bar) => bar.rating != null);

    return Column(
      children: [
        // Filter and sort controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: FilterChipBar(
                  selectedMode: state.filterMode,
                  onFilterChanged: (mode) {
                    context.read<BarsListCubit>().setFilter(mode);
                  },
                ),
              ),
              SortDropdown(
                selectedSort: state.sortPreference,
                onSortChanged: (sort) {
                  // If user selects distance sort but we don't have location, request it
                  if (sort == SortPreference.distance && !hasDistanceData) {
                    _requestLocation();
                  }
                  context.read<BarsListCubit>().setSort(sort);
                },
                showDistanceOption: hasDistanceData || _hasLocationPermission,
                showRatingOption: hasRatingData,
              ),
            ],
          ),
        ),

        if (state.errorBanner != null)
          ErrorBanner(
            message: state.errorBanner!,
            onDismiss: () => context.read<BarsListCubit>().clearErrorBanner(),
            onRetry: () => context.read<BarsListCubit>().refresh(),
          ),

        Expanded(
          child: state.filteredBars.isEmpty
              ? _buildEmptyState(context, state.filterMode)
              : RefreshIndicator(
                  onRefresh: () async {
                    await context.read<BarsListCubit>().refresh();
                    if (_hasLocationPermission) {
                      await _updateBarsWithLocation();
                    }
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: state.filteredBars.length,
                    itemBuilder: (context, index) {
                      final bar = state.filteredBars[index];
                      return BarListItem(
                        bar: bar,
                        onTap: () => context.push('/bar/${bar.id}'),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, FilterMode filterMode) {
    final theme = Theme.of(context);
    final isFiltered = filterMode == FilterMode.ongoing;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFiltered ? Icons.access_time : Icons.sports_bar_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isFiltered ? 'No happy hours right now' : 'No bars found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? 'Check back later or view all bars'
                  : 'Pull down to refresh',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (isFiltered) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.read<BarsListCubit>().setFilter(FilterMode.all);
                },
                child: const Text('Show all bars'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
