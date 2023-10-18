import 'package:weather_app/domain/core/http_client/http_client.dart';
import 'package:weather_app/domain/core/http_client/response.dart';

class ApiWeather {
  static Future<QAResponse> searchLocation(String location) async {
    try {
      final res = await HttpClient(
        route: 'search.json?q=$location',
      ).get();
      final data = res!.data;
      return QAResponse(statusCode: res.statusCode, data: data);
    } on QAException<QAResponse> catch (exc) {
      throw QAResponse(
          statusCode: exc.error.statusCode, message: exc.error.message);
    }
  }

  static Future<QAResponse> fetchForecast(String location,
      {int days = 7}) async {
    try {
      final res = await HttpClient(
        route: 'forecast.json?q=$location&days=$days',
      ).get();
      final data = res!.data;
      return QAResponse(statusCode: res.statusCode, data: data);
    } on QAException<QAResponse> catch (exc) {
      throw QAResponse(
          statusCode: exc.error.statusCode, message: exc.error.message);
    }
  }
}
