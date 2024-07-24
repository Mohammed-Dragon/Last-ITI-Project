part of 'circular_indicator_cubit.dart';

sealed class CircularIndicatorState extends Equatable {
  const CircularIndicatorState();

  @override
  List<Object> get props => [];
}

final class CircularIndicatorInitial extends CircularIndicatorState {}

final class CircularIndicatorLoading extends CircularIndicatorState {}

final class CircularIndicatorSuccess extends CircularIndicatorState {}
