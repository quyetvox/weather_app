import 'package:weather_app/application/models/mforecast.dart';
import 'package:weather_app/application/models/mlocation.dart';
import 'package:weather_app/infastructor/local/local_storage.dart';

class AppStorage {
  AppStorage._privateConstructor();
  static final AppStorage instance = AppStorage._privateConstructor();

  List<MLocation> locations = [];
  Map<String, MForecast> mforecasts = {};

  Future init() async {
    await LocalStorage.instance.initShared();
    locations = LocalStorage.instance.locations
        .map((e) => MLocation.fromJson(e))
        .toList();
  }

  void saveLocations(MLocation _mLocation, MForecast _mForecast) {
    if (locations.where((element) => element.url == _mLocation.url).isEmpty) {
      locations.add(_mLocation);
    }
    _mForecast.location.url = _mLocation.url;
    mforecasts[_mLocation.url] = _mForecast;
    LocalStorage.instance.locations = locations.map((e) => e.toJson()).toList();
  }

  void removeLocation(String url) {
    locations.removeWhere((element) => element.url == url);
    mforecasts.remove(url);
    LocalStorage.instance.locations = locations.map((e) => e.toJson()).toList();
  }

  bool isExistLocation(String url) =>
      locations.where((element) => element.url == url).isNotEmpty;
}
