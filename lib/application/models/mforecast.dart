// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:weather_app/application/models/mforecast_day.dart';
import 'package:weather_app/application/models/mforecast_hour.dart';
import 'package:weather_app/application/models/mlocation.dart';

class MForecast {
  final MLocation location;
  final MForecastHour current;
  final List<MForecastDay> forecastday;

  MForecast({
    required this.location,
    required this.current,
    required this.forecastday,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location.toMap(),
      'current': current.toMap(),
      'forecastday': forecastday.map((x) => x.toMap()).toList(),
    };
  }

  factory MForecast.fromMap(Map<String, dynamic> map) {
    return MForecast(
      location: MLocation.fromMap(map['location'] as Map<String, dynamic>),
      current: MForecastHour.fromMap(map['current'] as Map<String, dynamic>),
      forecastday: List<MForecastDay>.from(
        (map['forecast']['forecastday'] as List).map<MForecastDay>(
          (x) => MForecastDay.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MForecast.fromJson(String source) =>
      MForecast.fromMap(json.decode(source) as Map<String, dynamic>);
}
