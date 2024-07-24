import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_app/Data/Models/get_countries_model.dart';
import 'package:sports_app/Data/Repository/get_countries_Repo.dart';

part 'football_countries_state.dart';

// class FootballCountriesCubit extends Cubit<FootballCountriesState> {
//   FootballCountriesCubit() : super(FootballCountriesInitial());

//   Future<void> fetchCountries() async {
//     try {
//       final response = await http.get(Uri.parse('https://apiv2.allsportsapi.com/football/?met=Countries&APIkey=62100878725f17609eea14c194265875c288ab8171d713f854c929bb76206eb2'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         emit(FootballCountriesLoaded(data.cast<String>()));
//       } else {
//         emit(FootballCountriesError('Failed to fetch countries'));
//       }
//     } catch (e) {
//       emit(FootballCountriesError('An error occurred'));
//     }
//   }
// }

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
