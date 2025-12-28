import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happyhour_app/domain/repositories/bar_repository.dart';
import 'package:happyhour_app/infrastructure/api/bars_api_client.dart';
import 'package:happyhour_app/presentation/cubits/bar_detail/bar_detail_state.dart';

/// Cubit for managing the bar detail screen state.
class BarDetailCubit extends Cubit<BarDetailState> {
  final BarRepository _repository;
  final int barId;

  BarDetailCubit({
    required BarRepository repository,
    required this.barId,
  }) : _repository = repository,
       super(const BarDetailInitial()) {
    loadBar();
  }

  /// Load the bar details.
  Future<void> loadBar() async {
    emit(const BarDetailLoading());

    try {
      final bars = await _repository.getAllBars();
      final bar = bars.firstWhere(
        (b) => b.id == barId,
        orElse: () => throw const BarsApiException('Bar not found'),
      );

      emit(
        BarDetailLoaded(
          bar: bar,
          isHappyHourActive: bar.isHappyHourActive(),
        ),
      );
    } on BarsApiException catch (e) {
      emit(BarDetailError(e.message));
    } catch (e) {
      emit(BarDetailError('Failed to load bar: $e'));
    }
  }

  /// Refresh the happy hour status.
  void refreshHappyHourStatus() {
    final currentState = state;
    if (currentState is BarDetailLoaded) {
      emit(
        BarDetailLoaded(
          bar: currentState.bar,
          isHappyHourActive: currentState.bar.isHappyHourActive(),
        ),
      );
    }
  }
}
