// class WeatherModel{
//   final temp;
//   final pressure;
//   final  humidity;
//   final temp_max;
//   final  temp_min;
//
//
//   double get getTemp => temp-272.5;
//   double get getMaxTemp => temp_max-272.5;
//   double get getMinTemp=> temp_min -272.5;
//
//   WeatherModel(this.temp, this.pressure, this.humidity, this.temp_max, this.temp_min);
//
//   factory WeatherModel.fromJson(Map<String, dynamic> json){
//     return WeatherModel(
//         json["temp"],
//         json["pressure"],
//         json["humidity"],
//         json["temp_max"],
//         json["temp_min"]
//     );
//   }
// }

import 'package:flutter_app/ParseTime.dart';
import 'package:flutter_app/Upperator.dart';

class WeatherModel {
  final city;
  final temperature;
  final pressure;
  final description;
  final sunrise;
  final sunset;
  final dateTime;
  final iconUrl;

  String get getCity => Upperator.upper(city);
  String get getTemp => (temperature - 273.15).round().toString();
  String get getSunrise => ParseTime.parse(sunrise);
  String get getSunset => ParseTime.parse(sunset);
  String get getSunriseSmol => ParseTime.parseSmol(sunrise);
  String get getSunsetSmol => ParseTime.parseSmol(sunset);
  WeatherModel(this.city, this.temperature, this.pressure, this.description,
      this.sunrise, this.sunset, this.dateTime, this.iconUrl);

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final url =
        'https://openweathermap.org/img/wn/${(json['weather'] as List).first['icon']}@2x.png';

    return WeatherModel(
      json['name'],

      json['main']['temp'],
      json['main']['pressure'],
      (json['weather'] as List).first['description'],

      json['sys']['sunrise'],
      json['sys']['sunset'],
      json['dt'],
      url,
    );
  }
}