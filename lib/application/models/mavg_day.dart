import 'dart:convert';

import 'package:weather_app/application/models/mcondition.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class MAvgDay {
  final double maxtemp_c;
  final double maxtemp_f;
  final double mintemp_c;
  final double mintemp_f;
  final double avgtemp_c;
  final double avgtemp_f;
  final double maxwind_kph;
  final double totalprecip_mm; // tong luong mua
  final double avgvis_km;
  final double avghumidity; //do am trung binh
  final double uv; //chi so uv
  final MCondition condition;

  MAvgDay({
    required this.maxtemp_c,
    required this.maxtemp_f,
    required this.mintemp_c,
    required this.mintemp_f,
    required this.avgtemp_c,
    required this.avgtemp_f,
    required this.maxwind_kph,
    required this.totalprecip_mm,
    required this.avgvis_km,
    required this.avghumidity,
    required this.uv,
    required this.condition,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'maxtemp_c': maxtemp_c,
      'maxtemp_f': maxtemp_f,
      'mintemp_c': mintemp_c,
      'mintemp_f': mintemp_f,
      'avgtemp_c': avgtemp_c,
      'avgtemp_f': avgtemp_f,
      'maxwind_kph': maxwind_kph,
      'totalprecip_mm': totalprecip_mm,
      'avgvis_km': avgvis_km,
      'avghumidity': avghumidity,
      'uv': uv,
      'condition': condition.toMap()
    };
  }

  factory MAvgDay.fromMap(Map<String, dynamic> map) {
    return MAvgDay(
      maxtemp_c: map['maxtemp_c'] as double,
      maxtemp_f: map['maxtemp_f'] as double,
      mintemp_c: map['mintemp_c'] as double,
      mintemp_f: map['mintemp_f'] as double,
      avgtemp_c: map['avgtemp_c'] as double,
      avgtemp_f: map['avgtemp_f'] as double,
      maxwind_kph: map['maxwind_kph'] as double,
      totalprecip_mm: map['totalprecip_mm'] as double,
      avgvis_km: map['avgvis_km'] as double,
      avghumidity: map['avghumidity'] as double,
      uv: map['uv'] as double,
      condition: MCondition.fromMap(map['condition'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MAvgDay.fromJson(String source) =>
      MAvgDay.fromMap(json.decode(source) as Map<String, dynamic>);
}
