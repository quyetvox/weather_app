import 'package:weather_app/application/models/mforecast.dart';
import 'package:weather_app/application/models/mlocation.dart';
import 'package:weather_app/infastructor/apis/api_weather.dart';

class AppWeather {
  static Future<List<MLocation>> searchLocation(String location) async {
    try {
      final res = await ApiWeather.searchLocation(location);
      final datas =
          (res.data as List).map((e) => MLocation.fromMap(e)).toList();
      return datas;
    } catch (e) {
      print("searchLocation error: $e");
      return [];
    }
  }

  static Future<MForecast?> fetchForecast(String location) async {
    try {
      final res = await ApiWeather.fetchForecast(location);
      return MForecast.fromMap(res.data);
    } catch (e) {
      print("fetchForecast error: $e");
      return null;
    }
  }
}
