import 'package:flutter/material.dart';
import 'package:weather_app/application/core/app_storage.dart';
import 'package:weather_app/presentation/help/navigation.dart';
import 'package:weather_app/presentation/screens/main_screen.dart';
import 'package:weather_app/presentation/screens/search_location_screen.dart';
import 'package:weather_app/presentation/screens/splash_screen.dart';
import 'package:weather_app/presentation/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App-Weather',
      debugShowCheckedModeBanner: false,
      navigatorKey: Navigation.navigatorKey,
      scaffoldMessengerKey: Navigation.scaffoldMessengerKey,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      home: const LaunchScreen(),
    );
  }
}

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  bool _ready = false;

  @override
  void initState() {
    _ready = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SearchLocationScreen();
  }
}
