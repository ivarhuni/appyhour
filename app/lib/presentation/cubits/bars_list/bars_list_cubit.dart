import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happyhour_app/domain/entities/bar.dart';
import 'package:happyhour_app/domain/repositories/bar_repository.dart';
import 'package:happyhour_app/domain/value_objects/filter_mode.dart';
import 'package:happyhour_app/domain/value_objects/sort_preference.dart';
import 'package:happyhour_app/infrastructure/api/bars_api_client.dart';
import 'package:happyhour_app/presentation/cubits/bars_list/bars_list_state.dart';

/// Cubit for managing the bars list screen state.
class BarsListCubit extends Cubit<BarsListState> {
  final BarRepository _repository;

  BarsListCubit({required BarRepository repository})
    : _repository = repository,
      super(const BarsListInitial());

  /// Load all bars from the repository.
  Future<void> loadBars() async {
    emit(const BarsListLoading());

    try {
      final bars = await _repository.getAllBars();
      emit(
        BarsListLoaded(
          bars: bars,
          filteredBars: bars,
        ),
      );
    } on BarsApiException catch (e) {
      emit(BarsListError(e.message));
    } catch (e) {
      emit(BarsListError('Failed to load bars: $e'));
    }
  }

  /// Refresh bars (pull-to-refresh).
  Future<void> refresh() async {
    final currentState = state;

    try {
      final bars = await _repository.getAllBars();

      if (currentState is BarsListLoaded) {
        final filteredBars = _applyFilterAndSort(
          bars,
          currentState.filterMode,
          currentState.sortPreference,
        );
        emit(
          currentState.copyWith(
            bars: bars,
            filteredBars: filteredBars,
            clearErrorBanner: true,
          ),
        );
      } else {
        emit(
          BarsListLoaded(
            bars: bars,
            filteredBars: bars,
          ),
        );
      }
    } on BarsApiException catch (e) {
      if (currentState is BarsListLoaded) {
        emit(currentState.copyWith(errorBanner: e.message));
      } else {
        emit(BarsListError(e.message));
      }
    } catch (e) {
      if (currentState is BarsListLoaded) {
        emit(currentState.copyWith(errorBanner: e.toString()));
      } else {
        emit(BarsListError('Failed to refresh: $e'));
      }
    }
  }

  /// Set the filter mode.
  void setFilter(FilterMode filterMode) {
    final currentState = state;
    if (currentState is BarsListLoaded) {
      final filteredBars = _applyFilterAndSort(
        currentState.bars,
        filterMode,
        currentState.sortPreference,
      );
      emit(
        currentState.copyWith(
          filterMode: filterMode,
          filteredBars: filteredBars,
        ),
      );
    }
  }

  /// Set the sort preference.
  void setSort(SortPreference sortPreference) {
    final currentState = state;
    if (currentState is BarsListLoaded) {
      final filteredBars = _applyFilterAndSort(
        currentState.bars,
        currentState.filterMode,
        sortPreference,
      );
      emit(
        currentState.copyWith(
          sortPreference: sortPreference,
          filteredBars: filteredBars,
        ),
      );
    }
  }

  /// Update bars with distance from user.
  void updateBarsWithDistance(List<Bar> barsWithDistance) {
    final currentState = state;
    if (currentState is BarsListLoaded) {
      final filteredBars = _applyFilterAndSort(
        barsWithDistance,
        currentState.filterMode,
        currentState.sortPreference,
      );
      emit(
        currentState.copyWith(
          bars: barsWithDistance,
          filteredBars: filteredBars,
        ),
      );
    }
  }

  /// Clear the error banner.
  void clearErrorBanner() {
    final currentState = state;
    if (currentState is BarsListLoaded) {
      emit(currentState.copyWith(clearErrorBanner: true));
    }
  }

  List<Bar> _applyFilterAndSort(
    List<Bar> bars,
    FilterMode filterMode,
    SortPreference sortPreference,
  ) {
    // Apply filter
    List<Bar> filtered;
    if (filterMode == FilterMode.ongoing) {
      final now = DateTime.now();
      filtered = bars.where((bar) => bar.isHappyHourActive(now)).toList();
    } else {
      filtered = List.from(bars);
    }

    // Apply sort
    switch (sortPreference) {
      case SortPreference.serverOrder:
        // Keep original order
        break;
      case SortPreference.beerPrice:
        filtered.sort((a, b) {
          final priceCompare = a.cheapestBeerPrice.compareTo(
            b.cheapestBeerPrice,
          );
          if (priceCompare != 0) return priceCompare;
          return a.name.compareTo(b.name);
        });
      case SortPreference.distance:
        filtered.sort((a, b) {
          // Bars without distance go to the end
          if (a.distanceFromUser == null && b.distanceFromUser == null) {
            return a.name.compareTo(b.name);
          }
          if (a.distanceFromUser == null) return 1;
          if (b.distanceFromUser == null) return -1;
          return a.distanceFromUser!.compareTo(b.distanceFromUser!);
        });
      case SortPreference.rating:
        filtered.sort((a, b) {
          // Bars without rating go to the end
          if (a.rating == null && b.rating == null) {
            return a.name.compareTo(b.name);
          }
          if (a.rating == null) return 1;
          if (b.rating == null) return -1;
          // Higher rating first (descending)
          return b.rating!.compareTo(a.rating!);
        });
    }

    return filtered;
  }
}
