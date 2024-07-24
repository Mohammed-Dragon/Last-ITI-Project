import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sports_app/Data/Models/get_players_model.dart';

String player_name = "";
var team_id;
var temp;

class GetPlayersRepo {
  Future<GetPlayersModel?> getPlayers() async {
    try {
      temp = team_id;
      var playersresponse = await http.get(
        Uri.parse(
            "https://apiv2.allsportsapi.com/football/?&met=Players&teamId=${team_id ?? 0}&playerName=${player_name}&APIkey=7e01756836c2931c6efb376a90181e8a3e060d483f636ca4215f660e0c64fe0f"),
      );

      var decodedResponse = jsonDecode(playersresponse.body);

      if (playersresponse.statusCode == 200) {
        GetPlayersModel myResponse = GetPlayersModel.fromJson(decodedResponse);

        return myResponse;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
