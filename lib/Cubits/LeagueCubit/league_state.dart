part of 'league_cubit.dart';

sealed class LeagueState {}

final class LeagueInitial extends LeagueState {}

final class LeagueLoading extends LeagueState {}

final class LeagueSuccess extends LeagueState {
  final LeagueModel? response;
  LeagueSuccess({required this.response});
}

final class LeagueError extends LeagueState {}
