import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MLocation {
  final double lat;
  final double lon;
  final String name;
  final String region;
  final String country;
  String url;
  final int localtime_epoch;
  String localtime;
  MLocation({
    required this.lat,
    required this.lon,
    required this.name,
    required this.region,
    required this.country,
    required this.url,
    required this.localtime_epoch,
    required this.localtime,
  }) {
    if (url.isEmpty) url = '$name-$region-$country'.replaceAll(" ", "-");
    if (localtime.isEmpty) {
      var now = DateTime.now();
      localtime =
          "${now.year}-${now.month}-${now.day} ${now.hour}:${now.second}";
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lon': lon,
      'name': name,
      'region': region,
      'country': country,
      'url': url,
      'localtime_epoch': localtime_epoch,
      'localtime': localtime
    };
  }

  factory MLocation.fromMap(Map<String, dynamic> map) {
    return MLocation(
        url: (map['url'] ?? '') as String,
        lat: map['lat'] as double,
        lon: map['lon'] as double,
        name: map['name'] as String,
        region: map['region'] as String,
        country: map['country'] as String,
        localtime_epoch: (map['localtime_epoch'] ?? 0) as int,
        localtime: (map['localtime'] ?? '') as String);
  }

  String toJson() => json.encode(toMap());

  factory MLocation.fromJson(String source) =>
      MLocation.fromMap(json.decode(source) as Map<String, dynamic>);
}
