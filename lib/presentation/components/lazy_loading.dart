import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/presentation/help/navigation.dart';

class Loading {
  static OverlayEntry? _overlay;
  static _Loading? _loading;
  static void show() {
    if (_overlay != null) {
      return;
    }
    _loading = _Loading();
    _overlay = OverlayEntry(builder: (BuildContext context) => _loading!);
    Navigator.of(Navigation.contextRoot).overlay!.insert(_overlay!);
  }

  static void hide([void Function()? completion]) {
    try {
      _loading?.hide(() {
        _overlay?.remove();
        _overlay = null;
        _loading = null;
        if (completion != null) {
          completion();
        }
      });
    } catch (error) {
      print(error);
    }
  }
}

class _Loading extends StatefulWidget {
  _Loading({Key? key}) : super(key: key);
  final __LoadingState myAppState = __LoadingState();

  @override
  __LoadingState createState() => myAppState;

  hide(Function completion) {
    myAppState.hide(completion);
  }
}

class __LoadingState extends State<_Loading> {
  final _visible = true;

  hide(Function completion) {
    completion();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withAlpha(100),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black45,
            ),
            child: const Center(
              child: CupertinoActivityIndicator(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: CupertinoActivityIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
