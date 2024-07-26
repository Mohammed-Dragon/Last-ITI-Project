import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_app/Data/Models/get_countries_model.dart';
import 'package:sports_app/Data/Repository/get_countries_Repo.dart';

part 'football_countries_state.dart';

class FootballCountriesCubit extends Cubit<FootballCountriesState> {
  FootballCountriesCubit() : super(FootballCountriesInitial());

  GetCountriesRepo countriesRepo = GetCountriesRepo();

  Future<void> getCountries() async {
    emit(FootballCountriesLoading());

    try {
      await countriesRepo.getCountries().then((value) {
        if (value != null) {
          emit(FootballCountriesSuccess(response: value));
        } else {
          emit(FootballCountriesError('Failed to fetch countries'));
        }
      });
    } catch (error) {
      emit(FootballCountriesError('An error occurred'));
    }
  }
}
