part of 'slider_cubit.dart';

@immutable
sealed class SliderState {}

final class SliderInitial extends SliderState {}

final class AutoState extends SliderState {}

final class ButtonState extends SliderState {}
