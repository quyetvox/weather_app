import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._privateConstructor();
  static final LocalStorage instance = LocalStorage._privateConstructor();

  SharedPreferences? _pref;

  Future<SharedPreferences?> initShared() async {
    _pref ??= await SharedPreferences.getInstance();
    return _pref;
  }

  List<String> get locations {
    return (instance._pref?.getStringList(KeySharedPreferences.locations)) ??
        [];
  }

  set locations(List<String> locations) {
    instance._pref?.setStringList(KeySharedPreferences.locations, locations);
  }
}

class KeySharedPreferences {
  static const String locations = "locations";
}
