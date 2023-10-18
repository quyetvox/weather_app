// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:weather_app/application/models/mcondition.dart';

class MForecastHour {
  final int time_epoch;
  final String time;
  final double temp_c;
  final double temp_f;
  final MCondition condition;
  final double wind_kph; // Toc do gio toi da km/h
  final int wind_degree; //gio theo do
  final double pressure_mb; //ap suat
  final double precip_mm; //Luong mua milimet
  final int humidity; //do am %
  final int cloud; // do che phu may %
  final double feelslike_c; //nhiet do cam thay oC
  final double feelslike_f; //nhiet do cam thay oF
  final double dewpoint_c; //diem suong oC
  final double dewpoint_f; //diem suong oF
  final int is_day; //0 la dem, 1 la ngay
  final double vis_km; //tam nhin km
  final double uv; //chi so tia uv
  MForecastHour({
    required this.time_epoch,
    required this.time,
    required this.temp_c,
    required this.temp_f,
    required this.condition,
    required this.wind_kph,
    required this.wind_degree,
    required this.pressure_mb,
    required this.precip_mm,
    required this.humidity,
    required this.cloud,
    required this.feelslike_c,
    required this.feelslike_f,
    required this.dewpoint_c,
    required this.dewpoint_f,
    required this.is_day,
    required this.vis_km,
    required this.uv,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time_epoch': time_epoch,
      'time': time,
      'temp_c': temp_c,
      'temp_f': temp_f,
      'condition': condition.toMap(),
      'wind_kph': wind_kph,
      'wind_degree': wind_degree,
      'pressure_mb': pressure_mb,
      'precip_mm': precip_mm,
      'humidity': humidity,
      'cloud': cloud,
      'feelslike_c': feelslike_c,
      'feelslike_f': feelslike_f,
      'dewpoint_c': dewpoint_c,
      'dewpoint_f': dewpoint_f,
      'is_day': is_day,
      'vis_km': vis_km,
      'uv': uv,
    };
  }

  factory MForecastHour.fromMap(Map<String, dynamic> map) {
    return MForecastHour(
      time_epoch: (map['time_epoch'] ?? map['last_updated_epoch']) as int,
      time: (map['time'] ?? map['last_updated']) as String,
      temp_c: map['temp_c'] as double,
      temp_f: map['temp_f'] as double,
      condition: MCondition.fromMap(map['condition'] as Map<String, dynamic>),
      wind_kph: map['wind_kph'] as double,
      wind_degree: map['wind_degree'] as int,
      pressure_mb: map['pressure_mb'] as double,
      precip_mm: map['precip_mm'] as double,
      humidity: map['humidity'] as int,
      cloud: map['cloud'] as int,
      feelslike_c: map['feelslike_c'] as double,
      feelslike_f: map['feelslike_f'] as double,
      dewpoint_c: (map['dewpoint_c'] ?? 0.0) as double,
      dewpoint_f: (map['dewpoint_f'] ?? 0.0) as double,
      is_day: map['is_day'] as int,
      vis_km: map['vis_km'] as double,
      uv: map['uv'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory MForecastHour.fromJson(String source) =>
      MForecastHour.fromMap(json.decode(source) as Map<String, dynamic>);
}
