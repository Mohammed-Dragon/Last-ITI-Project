import 'package:bloc/bloc.dart';
import 'package:sports_app/Data/Models/get_teams_model.dart';
import 'package:sports_app/Data/Repository/get_teams_data_repo.dart';
part 'get_teams_state.dart';

class GetTeamsCubit extends Cubit<GetTeamsState> {
  GetTeamsCubit() : super(GetTeamsInitial());
  GetTeamsRepo teamsRepo = GetTeamsRepo();

  getTeams() async {
    emit(GetTeamsLoading());

    try {
      await teamsRepo.getTeams().then((value) {
        if (value != null) {
          emit(GetTeamsSuccess(teamsresponse: value));
        } else {
          emit(GetTeamsError());
        }
      });
    } catch (error) {
      emit(GetTeamsError());
    }
  }
}
