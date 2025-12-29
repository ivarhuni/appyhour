import 'package:equatable/equatable.dart';
import 'package:happyhour_app/domain/bars/entities/bar.dart';
import 'package:happyhour_app/domain/bars/enums/filter_mode.dart';
import 'package:happyhour_app/domain/bars/enums/sort_preference.dart';

/// Sealed class for bars list screen state.
sealed class BarListState extends Equatable {
  const BarListState();
}

class BarListInitial extends BarListState {
  const BarListInitial();

  @override
  List<Object?> get props => [];
}

class BarListLoading extends BarListState {
  const BarListLoading();

  @override
  List<Object?> get props => [];
}

class BarListLoaded extends BarListState {
  final List<Bar> bars;
  final List<Bar> filteredBars;
  final FilterMode filterMode;
  final SortPreference sortPreference;
  final String? errorBanner;

  const BarListLoaded({
    required this.bars,
    required this.filteredBars,
    this.filterMode = FilterMode.all,
    this.sortPreference = SortPreference.serverOrder,
    this.errorBanner,
  });

  BarListLoaded copyWith({
    List<Bar>? bars,
    List<Bar>? filteredBars,
    FilterMode? filterMode,
    SortPreference? sortPreference,
    String? errorBanner,
    bool clearErrorBanner = false,
  }) {
    return BarListLoaded(
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

class BarListError extends BarListState {
  final String message;

  const BarListError(this.message);

  @override
  List<Object?> get props => [message];
}
