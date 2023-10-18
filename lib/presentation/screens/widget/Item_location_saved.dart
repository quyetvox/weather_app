import 'package:flutter/material.dart';
import 'package:weather_app/application/core/app_storage.dart';
import 'package:weather_app/application/core/app_weather.dart';
import 'package:weather_app/application/models/mforecast.dart';
import 'package:weather_app/application/models/mlocation.dart';
import 'package:weather_app/presentation/components/custom_button.dart';
import 'package:weather_app/presentation/components/custom_glass.dart';
import 'package:weather_app/presentation/help/navigation.dart';
import 'package:weather_app/presentation/screens/main_screen.dart';
import 'package:weather_app/presentation/screens/widget/text_widget.dart';

import '../../components/lazy_loading.dart';

class ItemLocationSaved extends StatefulWidget {
  const ItemLocationSaved(
      {super.key, required this.mLocation, required this.onPressed});
  final MLocation mLocation;
  final Function onPressed;

  @override
  State<ItemLocationSaved> createState() => _ItemLocationSavedState();
}

class _ItemLocationSavedState extends State<ItemLocationSaved> {
  Future<MForecast> _fetchWeather() async {
    var data = AppStorage.instance.mforecasts[widget.mLocation.url];
    if (data != null) return data;
    data = await AppWeather.fetchForecast(widget.mLocation.url);
    AppStorage.instance.saveLocations(widget.mLocation, data!);
    return data;
  }

  @override
  Widget build(BuildContext context) {
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
            return textNotFoundData(widget.mLocation.name);
          } else if (snapshot.hasData) {
            return _buildLocationSaveItem(snapshot.data as MForecast);
          } else {
            return textEmptyData(widget.mLocation.name);
          }
        } else {
          return textEmptyData(widget.mLocation.name);
        }
      },
    );
  }

  Widget _buildLocationSaveItem(MForecast mForecast) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () => Navigation.push(MainScreen(mLocation: mForecast.location)),
        onLongPress: () {
          showModalBottomSheet(
              backgroundColor: Colors.black54,
              isScrollControlled: false,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 50),
                  child: Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text("Do you want to delete?",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white)),
                        Text("${mForecast.location.name}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Colors.white)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                                label: 'Cancel',
                                onPressed: () => Navigation.pop()),
                            CustomButton(
                                label: 'OK',
                                onPressed: () => widget.onPressed())
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: CustomGlass(
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: mForecast.location.url,
                            child: Text(mForecast.location.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          Text(mForecast.location.localtime.split(" ")[1],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.grey.shade300)),
                        ],
                      ),
                      Text(mForecast.current.condition.text,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.white))
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${mForecast.current.temp_c}°C",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                      Text(
                          "C:${mForecast.forecastday.first.day.maxtemp_c}° T:${mForecast.forecastday.first.day.mintemp_c}°",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
