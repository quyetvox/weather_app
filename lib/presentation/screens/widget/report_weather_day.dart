import 'package:flutter/material.dart';
import 'package:weather_app/application/models/mforecast.dart';
import 'package:weather_app/application/models/mforecast_day.dart';
import 'package:weather_app/presentation/components/custom_glass.dart';

class ReportWeatherDay extends StatelessWidget {
  const ReportWeatherDay({
    super.key,
    required this.mForecast,
  });
  final MForecast mForecast;

  @override
  Widget build(BuildContext context) {
    return CustomGlass(
      child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: mForecast.forecastday
              .map((e) => _buildItemReportDay(
                  e, mForecast.current.time.split(' ')[0], context))
              .toList()),
    );
  }

  Widget _buildItemReportDay(
      MForecastDay mForecastDay, String currentDay, context) {
    String textDay = '';
    if (mForecastDay.date == currentDay) {
      textDay = "To day";
    } else {
      var formatDay = mForecastDay.date.split(' ')[0].split('-');
      textDay = "${formatDay[2]}/${formatDay[1]}";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(textDay,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white)),
        Image.network(mForecastDay.day.condition.icon, width: 40, height: 40),
        Text(
            "T:${mForecastDay.day.mintemp_c}C° C:${mForecastDay.day.maxtemp_c}C°",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white))
      ],
    );
  }
}
