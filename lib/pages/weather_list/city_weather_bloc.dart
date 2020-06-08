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
      .startWith(true)
      .switchMap((value) => client
          .getCurrentWeather(cityName)
          .asStream()
          // .delay(Duration(seconds: 4))
          .startWith(null))
      .doOnError((error, stacktrace) => print('oh, no! $error / $stacktrace'))
      .shareValue();

  final String cityName;
  final WeatherClient client;
  final Stream<bool> refreshRequest;
}
