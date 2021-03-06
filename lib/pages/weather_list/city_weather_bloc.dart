import 'package:flutter/foundation.dart';
import 'package:openweather_app/model/weather.dart';
import 'package:openweather_app/services/weather_client.dart';
import 'package:rxdart/rxdart.dart';

class CityWeatherBloc {
  CityWeatherBloc({
    @required this.cityName,
    @required this.client,
    @required this.refreshRequest,
  });

  Stream<Weather> get currentWeather => refreshRequest
      .asBroadcastStream()
      .startWith(false)
      .switchMap((value) => client
          .getCurrentWeather(cityName, forceRefresh: value)
          .asStream()
          // .delay(Duration(seconds: 4))
          .startWith(null))
      .shareValue();

  final String cityName;
  final WeatherClient client;
  final Stream<bool> refreshRequest;
}
