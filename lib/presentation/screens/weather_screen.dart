import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:weather_app/application/core/app_storage.dart';
import 'package:weather_app/application/core/app_weather.dart';
import 'package:weather_app/application/models/mforecast.dart';
import 'package:weather_app/application/models/mlocation.dart';
import 'package:weather_app/presentation/components/animated_backgroud.dart';
import 'package:weather_app/presentation/components/custom_divider.dart';
import 'package:weather_app/presentation/components/custom_glass.dart';
import 'package:weather_app/presentation/components/lazy_loading.dart';
import 'package:weather_app/presentation/screens/widget/report_weather_day.dart';
import 'package:weather_app/presentation/screens/widget/report_weather_hour.dart';
import 'package:weather_app/presentation/screens/widget/text_widget.dart';
import 'package:weather_app/presentation/styles/colors.dart';

// ignore: must_be_immutable
class WeatherScreen extends StatefulWidget {
  WeatherScreen({super.key, required this.mLocation, this.onPressed});
  final MLocation? mLocation;
  Function(MForecast mForecast, MLocation mLocation)? onPressed;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherType? weatherType;

  Future<MForecast> _fetchWeather() async {
    var data = await AppWeather.fetchForecast(widget.mLocation!.url);
    if (AppStorage.instance.mforecasts[widget.mLocation!.url] != null) {
      AppStorage.instance.saveLocations(widget.mLocation!, data!);
    }
    return data!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(gradient: backgroundWeatherTheme(context).backround),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBackground(weatherType),
            widget.mLocation == null
                ? const SizedBox.shrink()
                : _buildGridInfoWeather(),
          ],
        ),
      ),
    );
  }

  Widget _buildGridInfoWeather() {
    return FutureBuilder<dynamic>(
      future: _fetchWeather(),
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return textNotFoundData(widget.mLocation!.name);
          } else if (snapshot.hasData) {
            return _buildWeatherWidget(snapshot.data as MForecast);
          } else {
            return textEmptyData(widget.mLocation!.name);
          }
        } else {
          return textEmptyData(widget.mLocation!.name);
        }
      },
    );
  }

  Widget _buildWeatherWidget(MForecast mForecast) {
    weatherType = mForecast.current.is_day == 1
        ? WeatherType.sunny
        : WeatherType.cloudyNight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Container(
          height: 50,
          alignment: Alignment.center,
          child: Row(
            children: [
              AppStorage.instance.isExistLocation(widget.mLocation!.url)
                  ? IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white))
                  : const SizedBox(width: 60),
              Expanded(
                child: Hero(
                  tag: mForecast.location.url,
                  child: Text(
                    mForecast.location.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              AppStorage.instance.isExistLocation(widget.mLocation!.url)
                  ? const SizedBox(width: 60)
                  : IconButton(
                      onPressed: () =>
                          widget.onPressed!(mForecast, widget.mLocation!),
                      icon: const Icon(Icons.save_as_outlined,
                          color: Colors.white))
            ],
          ),
        ),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
            children: [
              _weatherDetail(context, mForecast),
              const ColumnDivider(space: 20),
              ReportWeatherHour(mForecast: mForecast),
              const ColumnDivider(space: 20),
              ReportWeatherDay(mForecast: mForecast),
              GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  children: [
                    CustomGlass(
                      child: _boxItemWidget(
                        Icons.wind_power,
                        "Wind",
                        "${mForecast.current.wind_kph} km/h",
                        "Wind Deg : ${mForecast.current.wind_degree}°",
                      ),
                    ),
                    CustomGlass(
                      child: _boxItemWidget(
                        Icons.sunny_snowing,
                        "Sunrise",
                        mForecast.current.is_day == 1
                            ? mForecast.forecastday.first.astro.sunrise
                            : mForecast.forecastday[2].astro.sunrise,
                        "Sunset will be at : ${mForecast.current.is_day == 1 ? mForecast.forecastday.first.astro.sunset : mForecast.forecastday[2].astro.sunset}",
                      ),
                    ),
                    CustomGlass(
                      child: _boxItemWidget(
                        Icons.thermostat,
                        "Temperature",
                        "${mForecast.current.temp_c}°C",
                        "Feels like : ${mForecast.current.feelslike_c}°C",
                      ),
                    ),
                    CustomGlass(
                      child: _boxItemWidget(
                        Icons.water_drop,
                        "Amount of rain",
                        "${mForecast.current.precip_mm} mm",
                        "Dewpoint : ${mForecast.current.dewpoint_c}°C",
                      ),
                    ),
                    CustomGlass(
                      child: _boxItemWidget(
                        Icons.cloud,
                        "Clouds",
                        "${mForecast.current.cloud}%",
                        "Visibility : ${mForecast.current.vis_km} km",
                      ),
                    ),
                    CustomGlass(
                      child: _boxItemWidget(
                        Icons.water_drop,
                        "Humidity",
                        "${mForecast.current.humidity}%",
                        "Pressure : ${mForecast.current.pressure_mb} mbar",
                      ),
                    ),
                  ])
            ],
          ),
        ),
      ],
    );
  }

  //DateFormat.Hm().format(DateTime.now())
  Widget _boxItemWidget(IconData icon, String title, String value,
      [String? subtitle]) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey.shade300, size: 15),
              const RowDivider(space: 5),
              Expanded(
                  child: Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Colors.grey.shade300))),
            ],
          ),
          const ColumnDivider(space: 5),
          Expanded(
              child: Text(value,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          if (subtitle != null)
            Text(subtitle,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white))
        ],
      ),
    );
  }

  Widget _weatherDetail(BuildContext context, MForecast mForecast) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: [
        Text("${mForecast.current.temp_c}°C",
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.white)),
        const ColumnDivider(space: 3),
        Text(mForecast.current.condition.text,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        const ColumnDivider(space: 5),
        Text(
            "C:${mForecast.forecastday.first.day.maxtemp_c}° T:${mForecast.forecastday.first.day.mintemp_c}°",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white)),
      ]),
    );
  }

  Widget _introText(BuildContext context) {
    return Positioned(
      top: 30,
      left: 20,
      child: SafeArea(
        child: Text("Please wait\nBest things always took time...",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w100)),
      ),
    );
  }
}
