part of 'football_countries_cubit.dart';

// @immutable
sealed class FootballCountriesState {}

final class FootballCountriesInitial extends FootballCountriesState {}

final class FootballCountriesLoading extends FootballCountriesState {}

final class FootballCountriesSuccess extends FootballCountriesState {
  final GetCountriesModel response;
  FootballCountriesSuccess({required this.response});
}

final class FootballCountriesError extends FootballCountriesState {
  late final String errorMessage;
  FootballCountriesError(this.errorMessage);
  List<Object> get props => [errorMessage];
}
