import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happyhour_app/application/bars/bar_list/bar_list_state.dart';
import 'package:happyhour_app/domain/bars/entities/bar.dart';
import 'package:happyhour_app/domain/bars/enums/filter_mode.dart';
import 'package:happyhour_app/domain/bars/enums/sort_preference.dart';
import 'package:happyhour_app/infrastructure/bars/repository/i_bar_repository.dart';

/// Cubit for managing the bars list screen state.
class BarListCubit extends Cubit<BarListState> {
  final IBarRepository _repository;

  BarListCubit({required IBarRepository repository})
    : _repository = repository,
      super(const BarListInitial());

  /// Load all bars from the repository.
  Future<void> loadBars() async {
    emit(const BarListLoading());

    try {
      final bars = await _repository.getAllBars();
      emit(
        BarListLoaded(
          bars: bars,
          filteredBars: bars,
        ),
      );
    } on BarRepositoryException catch (e) {
      emit(BarListError(e.message));
    } catch (e) {
      emit(BarListError('Failed to load bars: $e'));
    }
  }

  /// Refresh bars (pull-to-refresh).
  Future<void> refresh() async {
    final currentState = state;

    try {
      final bars = await _repository.getAllBars();

      if (currentState is BarListLoaded) {
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
          BarListLoaded(
            bars: bars,
            filteredBars: bars,
          ),
        );
      }
    } on BarRepositoryException catch (e) {
      if (currentState is BarListLoaded) {
        emit(currentState.copyWith(errorBanner: e.message));
      } else {
        emit(BarListError(e.message));
      }
    } catch (e) {
      if (currentState is BarListLoaded) {
        emit(currentState.copyWith(errorBanner: e.toString()));
      } else {
        emit(BarListError('Failed to refresh: $e'));
      }
    }
  }

  /// Set the filter mode.
  void setFilter(FilterMode filterMode) {
    final currentState = state;
    if (currentState is BarListLoaded) {
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
    if (currentState is BarListLoaded) {
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
    if (currentState is BarListLoaded) {
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
    if (currentState is BarListLoaded) {
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
