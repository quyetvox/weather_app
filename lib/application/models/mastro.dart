import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MAstro {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  MAstro({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sunrise': sunrise,
      'sunset': sunset,
      'moonrise': moonrise,
      'moonset': moonset,
    };
  }

  factory MAstro.fromMap(Map<String, dynamic> map) {
    return MAstro(
      sunrise: map['sunrise'] as String,
      sunset: map['sunset'] as String,
      moonrise: map['moonrise'] as String,
      moonset: map['moonset'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MAstro.fromJson(String source) => MAstro.fromMap(json.decode(source) as Map<String, dynamic>);
}
