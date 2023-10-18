import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Navigation {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  static PageController scrollController = PageController();

  static NavigatorState get stateRoot => navigatorKey.currentState!;
  static BuildContext get contextRoot => navigatorKey.currentContext!;
  static Size get size => MediaQuery.of(contextRoot).size;
  static double get widthPC => size.width / 5 * 4;
  static TextTheme get textTheme => Theme.of(contextRoot).textTheme;

  static readContext<VM>() => contextRoot.read<VM>();
  static watchContext<VM>() => contextRoot.watch<VM>();
  static selectContext<VM>() => contextRoot.select((VM vm) => vm);

  static Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  static Future<dynamic> pushReplacementNamed(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> pushReplacement(Widget component,
      {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
        builder: (_) => component,
        settings: RouteSettings(arguments: arguments)));
  }

  static Future<dynamic> pushAndRemoveUntil(Widget component,
      {Object? arguments}) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => component,
            settings: RouteSettings(arguments: arguments)),
        (route) => false);
  }

  static Future<dynamic> push(Widget component,
      {Object? arguments, String? name}) {
    return navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (_) => component,
        settings: RouteSettings(arguments: arguments, name: name)));
  }

  static Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }

  static void pop() {
    navigatorKey.currentState!.pop();
  }
}
