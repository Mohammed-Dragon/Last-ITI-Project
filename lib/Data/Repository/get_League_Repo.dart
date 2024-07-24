import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sports_app/Data/Models/get_League_Model.dart';

var country_Id;

class GetLeagueRepo {
  Future<LeagueModel?> getLeague() async {
    String apiKey =
        "7e01756836c2931c6efb376a90181e8a3e060d483f636ca4215f660e0c64fe0f";
    try {
      var response = await http.get(Uri.parse(
          "https://apiv2.allsportsapi.com/football/?met=Leagues&countryId=${country_Id}&APIkey=$apiKey"));

      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var myResponse = LeagueModel.fromJson(decodedResponse);

        return myResponse;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
