import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_app/WeatherModel.dart';

class WeatherRepo{
  Future<WeatherModel> getWeather(String city) async{
    final result = await http.Client().get(Uri.https("api.openweathermap.org", "/data/2.5/weather", {"q":city, "APPID":"my APPID which I doesn't put here", "lang": "pl"}));

    if(result.statusCode != 200)
      throw Exception();

    return parsedJson(result.body);
  }

  WeatherModel parsedJson(final response){
    final jsonDecoded = json.decode(response);
    return WeatherModel.fromJson(jsonDecoded);
  }
}

