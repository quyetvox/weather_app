import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:weather_app/presentation/help/utils.dart';
import 'package:weather_app/presentation/styles/colors.dart';

// ignore: must_be_immutable
class AnimatedBackground extends StatelessWidget {
  AnimatedBackground(
    this.weatherType, {
    this.weatherTheme,
    Key? key,
  }) : super(key: key);

  WeatherType? weatherType;
  final ThemeWeather? weatherTheme;

  @override
  Widget build(BuildContext context) {
    ThemeWeather skyGradient = weatherTheme ?? backgroundWeatherTheme(context);
    //override weather type
    weatherType ??= alreadyNight ? WeatherType.sunnyNight : WeatherType.sunny;

    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: .5,
          child: WeatherBg(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            weatherType: weatherType!,
          ),
        ),
        if (weatherType == WeatherType.sunnyNight)
          Opacity(
            opacity: .5,
            child: Image.asset(
              "assets/images/aurora.png",
              height: MediaQuery.of(context).size.height / 1.5,
              fit: BoxFit.cover,
            ),
          ),
        Positioned(
          bottom: 0,
          height: MediaQuery.of(context).size.height,
          child: ShaderMask(
            shaderCallback: const LinearGradient(
              colors: [Colors.transparent, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader,
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(gradient: skyGradient.backround),
              child: Image.asset(
                "assets/images/deer.png",
                height: 150,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                color: skyGradient.deerColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
