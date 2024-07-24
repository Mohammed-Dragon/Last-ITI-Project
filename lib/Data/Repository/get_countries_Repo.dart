import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sports_app/Data/Models/get_countries_model.dart';

class GetCountriesRepo {
  Future<GetCountriesModel?> getCountries() async {
    try {
      String apiKey1 =
          '7e01756836c2931c6efb376a90181e8a3e060d483f636ca4215f660e0c64fe0f';
      var response = await http.get(Uri.parse(
          'https://apiv2.allsportsapi.com/football/?met=Countries&APIkey=$apiKey1'));
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        GetCountriesModel myCountrie =
            GetCountriesModel.fromJson(decodedResponse);
        return myCountrie;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
