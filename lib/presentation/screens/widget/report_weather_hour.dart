import 'package:flutter/material.dart';
import 'package:weather_app/application/models/mforecast.dart';
import 'package:weather_app/application/models/mforecast_hour.dart';
import 'package:weather_app/presentation/components/custom_glass.dart';

class ReportWeatherHour extends StatelessWidget {
  const ReportWeatherHour({super.key, required this.mForecast});
  final MForecast mForecast;

  @override
  Widget build(BuildContext context) {
    var index = int.parse(mForecast.current.time.split(" ")[1].split(":")[0]);
    List<MForecastHour> list = mForecast.forecastday.first.hour
        .sublist(index, mForecast.forecastday.first.hour.length);
    return CustomGlass(
      child: SizedBox(
        height: 100,
        child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: list.map((e) => _buildItemReportHour(e)).toList()),
      ),
    );
  }

  Widget _buildItemReportHour(MForecastHour mForecastHour) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${int.parse(mForecastHour.time.split(" ")[1].split(":")[0])}h',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Image.network(mForecastHour.condition.icon, width: 40, height: 40),
            Text("${mForecastHour.temp_c}°C",
                style: const TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
