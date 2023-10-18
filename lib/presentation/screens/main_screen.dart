import 'package:flutter/material.dart';
import 'package:weather_app/application/models/mlocation.dart';
import 'package:weather_app/presentation/components/custom_button.dart';
import 'package:weather_app/presentation/help/navigation.dart';
import 'package:weather_app/presentation/screens/weather_screen.dart';
import 'package:weather_app/presentation/styles/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, this.mLocation}) : super(key: key);
  final MLocation? mLocation;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWeatherTheme(context).deerColor,
      body: Column(
        children: [
          Expanded(
            child: WeatherScreen(mLocation: widget.mLocation),
          ),
          Divider(height: 0, color: Colors.white.withOpacity(.2)),
          _bottomWidget(context),
        ],
      ),
    );
  }

  Widget _bottomWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
                child: Text('Powered by Weather API',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white))),
            CustomButton(label: 'Search', onPressed: () => Navigation.pop())
          ],
        ),
      ),
    );
  }
}
