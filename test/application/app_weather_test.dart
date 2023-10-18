import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/application/core/app_weather.dart';

Future<void> main() async {
  group('Tests for fetch data ', () {
    test('search location', () async {
      final results = await AppWeather.searchLocation('paris');
      results.forEach((e) {
        print(e.toMap());
      });
    });

    test('forecast', () async {
      final results = await AppWeather.fetchForecast('paris');
      print(results!.current.toMap());
      print(results.forecastday.length);
      results.forecastday.forEach((element) {
        print(element.date);
        print(element.hour.first.toMap());
      });
      print(results.location.name);
    });
  });
}
