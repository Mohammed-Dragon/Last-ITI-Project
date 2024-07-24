import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sports_app/Data/Models/get_League_Model.dart';
import 'package:sports_app/Data/Repository/get_League_Repo.dart';

part 'league_state.dart';

class LeagueCubit extends Cubit<LeagueState> {
  LeagueCubit() : super(LeagueInitial());

  GetLeagueRepo leagueRepo = GetLeagueRepo();

  getLeague() async {
    emit(LeagueLoading());
    try {
      await leagueRepo.getLeague().then((value) {
        if (value != null) {
          emit(LeagueSuccess(response: value));
        } else {
          emit(LeagueError());
        }
      });
    } catch (error) {
      emit(LeagueError());
    }
  }
}
