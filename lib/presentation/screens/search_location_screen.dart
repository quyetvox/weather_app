import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:weather_app/application/core/app_storage.dart';
import 'package:weather_app/application/core/app_weather.dart';
import 'package:weather_app/application/models/mforecast.dart';
import 'package:weather_app/application/models/mlocation.dart';
import 'package:weather_app/presentation/components/animated_backgroud.dart';
import 'package:weather_app/presentation/components/custom_button.dart';
import 'package:weather_app/presentation/components/form_input.dart';
import 'package:weather_app/presentation/components/lazy_loading.dart';
import 'package:weather_app/presentation/help/navigation.dart';
import 'package:weather_app/presentation/screens/widget/Item_location_saved.dart';
import 'package:weather_app/presentation/styles/colors.dart';

import 'weather_screen.dart';
import 'widget/text_widget.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  WeatherType? weatherType;
  TextEditingController controller = TextEditingController();
  late ThemeWeather weatherTheme;
  List<MLocation> locations = [];
  String valueLocation = '';
  String oldValueLocation = '';
  bool isAction = false;

  @override
  void initState() {
    weatherTheme = backgroundWeatherTheme(context);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      randomAnimation();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List<MLocation>> _searchLocation() async {
    if (valueLocation.isEmpty) return [];
    if (oldValueLocation == valueLocation) return locations;
    locations = await AppWeather.searchLocation(valueLocation);
    return locations;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        oldValueLocation = valueLocation;
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(gradient: weatherTheme.backround),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              AnimatedBackground(weatherType, weatherTheme: weatherTheme),
              SafeArea(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SafeArea(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                "Search Location",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: InputWidget(
                                keyboardType: TextInputType.text,
                                kController: controller,
                                onSaved: (String? value) {},
                                onChanged: (String? value) {
                                  valueLocation = value!;
                                  if (valueLocation.isEmpty) {
                                    setState(() {});
                                  }
                                },
                                hintText: "City name/zip code",
                              ),
                            ),
                            const SizedBox(width: 10),
                            CustomButton(
                                label: "Search",
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  _searchLocation();
                                  setState(() {});
                                })
                          ],
                        ),
                      ),
                      Expanded(
                        child: valueLocation.isEmpty
                            ? _buildListLocationSave()
                            : _buildDataLocation(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataLocation() {
    return FutureBuilder<dynamic>(
      future: _searchLocation(),
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return textNotFoundData(valueLocation);
          } else if (snapshot.hasData) {
            return _buildListLocation(snapshot.data as List<MLocation>);
          } else {
            return textEmptyData(valueLocation);
          }
        } else {
          return textEmptyData(valueLocation);
        }
      },
    );
  }

  Widget _buildListLocation(List<MLocation> locations) {
    if (locations.isEmpty) {
      return textEmptyData(valueLocation);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: locations.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: false,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            height: Navigation.size.height - 200,
                            child: WeatherScreen(
                              mLocation: locations[index],
                              onPressed:
                                  (MForecast mForecast, MLocation mLocation) {
                                AppStorage.instance
                                    .saveLocations(mLocation, mForecast);
                                Navigation.pop();
                                setState(() {});
                              },
                            ));
                      });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white, width: 0.5)),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${locations[index].name}, ${locations[index].region}, ${locations[index].country}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  _buildListLocationSave() {
    return ListView(
        shrinkWrap: true,
        children: AppStorage.instance.locations
            .map(
              (e) => ItemLocationSaved(
                mLocation: e,
                onPressed: () {
                  {
                    AppStorage.instance.removeLocation(e.url);
                    Navigation.pop();
                    setState(() {
                      controller.text = '';
                      valueLocation = '';
                      _searchLocation();
                    });
                  }
                },
              ),
            )
            .toList());
  }

  void randomBackground() {
    setState(() {
      weatherTheme = weatherThemes[Random().nextInt(gradients.length)];
    });
  }

  void randomAnimation() {
    setState(() {
      weatherType =
          WeatherType.values[Random().nextInt(WeatherType.values.length)];
    });
  }
}
