// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:weather_app/application/models/mastro.dart';
import 'package:weather_app/application/models/mavg_day.dart';
import 'package:weather_app/application/models/mforecast_hour.dart';

class MForecastDay {
  final String date;
  final int date_epoch;
  final MAvgDay day;
  final MAstro astro;
  List<MForecastHour> hour;

  MForecastDay({
    required this.date,
    required this.date_epoch,
    required this.day,
    required this.astro,
    required this.hour,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'date_epoch': date_epoch,
      'day': day.toMap(),
      'astro': astro.toMap(),
      'hour': hour.map((x) => x.toMap()).toList(),
    };
  }

  factory MForecastDay.fromMap(Map<String, dynamic> map) {
    return MForecastDay(
      date: map['date'] as String,
      date_epoch: map['date_epoch'] as int,
      day: MAvgDay.fromMap(map['day'] as Map<String, dynamic>),
      astro: MAstro.fromMap(map['astro'] as Map<String, dynamic>),
      hour: List<MForecastHour>.from(
        (map['hour'] as List).map<MForecastHour>(
          (x) => MForecastHour.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MForecastDay.fromJson(String source) =>
      MForecastDay.fromMap(json.decode(source) as Map<String, dynamic>);
}
