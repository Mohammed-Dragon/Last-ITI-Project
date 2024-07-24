import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sports_app/Data/Models/get_goals_model.dart';
import 'package:sports_app/Data/Models/get_teams_model.dart';

var league_id;
var temp2;
String team_name = "";

class GetTeamsRepo {
  Future<GetTeamsModel?> getTeams() async {
    temp2 = league_id;
    try {
      var teamsresponse = await http.get(
        Uri.parse(
            "https://apiv2.allsportsapi.com/football/?&met=Teams&leagueId=${league_id}&teamName=${team_name}&APIkey=7e01756836c2931c6efb376a90181e8a3e060d483f636ca4215f660e0c64fe0f"),
      );

      var decodedResponse = jsonDecode(teamsresponse.body);

      if (teamsresponse.statusCode == 200) {
        GetTeamsModel myResponse = GetTeamsModel.fromJson(decodedResponse);

        print("heloooo ${myResponse}");

        return myResponse;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}

class GetGoalsRepo {
  Future<GetGoalsModel?> getGoals() async {
    try {
      var goalsresponse = await http.get(
        Uri.parse(
            "https://apiv2.allsportsapi.com/football/?&met=Topscorers&leagueId=${league_id}&APIkey=7e01756836c2931c6efb376a90181e8a3e060d483f636ca4215f660e0c64fe0f"),
      );

      var decodedResponse = jsonDecode(goalsresponse.body);

      if (goalsresponse.statusCode == 200) {
        GetGoalsModel myResponse = GetGoalsModel.fromJson(decodedResponse);

        return myResponse;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
