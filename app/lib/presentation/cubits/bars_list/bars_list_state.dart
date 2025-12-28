import 'package:equatable/equatable.dart';
import 'package:happyhour_app/domain/entities/bar.dart';
import 'package:happyhour_app/domain/value_objects/filter_mode.dart';
import 'package:happyhour_app/domain/value_objects/sort_preference.dart';

/// Sealed class for bars list screen state.
sealed class BarsListState extends Equatable {
  const BarsListState();
}

class BarsListInitial extends BarsListState {
  const BarsListInitial();

  @override
  List<Object?> get props => [];
}

class BarsListLoading extends BarsListState {
  const BarsListLoading();

  @override
  List<Object?> get props => [];
}

class BarsListLoaded extends BarsListState {
  final List<Bar> bars;
  final List<Bar> filteredBars;
  final FilterMode filterMode;
  final SortPreference sortPreference;
  final String? errorBanner;

  const BarsListLoaded({
    required this.bars,
    required this.filteredBars,
    this.filterMode = FilterMode.all,
    this.sortPreference = SortPreference.serverOrder,
    this.errorBanner,
  });

  BarsListLoaded copyWith({
    List<Bar>? bars,
    List<Bar>? filteredBars,
    FilterMode? filterMode,
    SortPreference? sortPreference,
    String? errorBanner,
    bool clearErrorBanner = false,
  }) {
    return BarsListLoaded(
      bars: bars ?? this.bars,
      filteredBars: filteredBars ?? this.filteredBars,
      filterMode: filterMode ?? this.filterMode,
      sortPreference: sortPreference ?? this.sortPreference,
      errorBanner: clearErrorBanner ? null : (errorBanner ?? this.errorBanner),
    );
  }

  @override
  List<Object?> get props => [
    bars,
    filteredBars,
    filterMode,
    sortPreference,
    errorBanner,
  ];
}

class BarsListError extends BarsListState {
  final String message;

  const BarsListError(this.message);

  @override
  List<Object?> get props => [message];
}
