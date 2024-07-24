part of 'players_cubit.dart';

@immutable
sealed class GetPlayersState {}

final class GetPlayersInitial extends GetPlayersState {}

final class GetPlayersLoading extends GetPlayersState {}

final class GetPlayersSuccess extends GetPlayersState {
  final GetPlayersModel playersresponse;
  GetPlayersSuccess({required this.playersresponse});
}

final class GetPlayersError extends GetPlayersState {}
