part of 'get_goals_cubit.dart';

abstract class GetGoalsState {}

class GetGoalsInitial extends GetGoalsState {}

class GetGoalsLoading extends GetGoalsState {}

class GetGoalsSuccess extends GetGoalsState {
  final GetGoalsModel goalsresponse;

  GetGoalsSuccess({required this.goalsresponse});
}

class GetGoalsError extends GetGoalsState {}
