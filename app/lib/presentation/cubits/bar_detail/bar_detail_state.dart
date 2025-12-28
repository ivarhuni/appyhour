import 'package:equatable/equatable.dart';
import 'package:happyhour_app/domain/entities/bar.dart';

/// Sealed class for bar detail screen state.
sealed class BarDetailState extends Equatable {
  const BarDetailState();
}

class BarDetailInitial extends BarDetailState {
  const BarDetailInitial();

  @override
  List<Object?> get props => [];
}

class BarDetailLoading extends BarDetailState {
  const BarDetailLoading();

  @override
  List<Object?> get props => [];
}

class BarDetailLoaded extends BarDetailState {
  final Bar bar;
  final bool isHappyHourActive;

  const BarDetailLoaded({
    required this.bar,
    required this.isHappyHourActive,
  });

  @override
  List<Object?> get props => [bar, isHappyHourActive];
}

class BarDetailError extends BarDetailState {
  final String message;

  const BarDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
