import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openweather_app/model/weather.dart';
import 'package:openweather_app/services/http_exception.dart';
import 'package:openweather_app/services/openweather/weather.dart'
    as api_weather;

abstract class OpenWeatherClient {
  Future<Weather> getCurrentWeather(String city);

  Future<Map<DateTime, Weather>> get7DaysForecast(City city);

  factory OpenWeatherClient({http.Client httpClient}) =>
      _OpenWeatherClient(httpClient);
}

class _OpenWeatherClient implements OpenWeatherClient {
  final http.Client client;

  _OpenWeatherClient(this.client);

  @override
  Future<Map<DateTime, Weather>> get7DaysForecast(City city) async {
    Uri requestUri = Uri.https(
      _authority,
      '$_apiPath/onecall',
      {
        'lat': city.lat.toString(),
        'lon': city.long.toString(),
        'exclude': 'current,minutely,hourly',
        'units': 'metric'
      },
    );
    var jsonResponse = await _readJson(client.get(requestUri));
    List<dynamic> forecast = jsonResponse['daily'];
    Iterable<MapEntry<DateTime, Weather>> forecastEntries =
        forecast.cast<Map<String, dynamic>>().skip(1)
            // skip current weather
            .map((daily) {
      int dateUnixUTC = daily['dt'];
      var dailyDate =
          DateTime.fromMillisecondsSinceEpoch(dateUnixUTC * 1000, isUtc: true);
      var dailyWeather = api_weather.Weather.fromForecastResponse(city, daily);
      return MapEntry<DateTime, Weather>(dailyDate, dailyWeather);
    });

    return Map.fromEntries(forecastEntries);
  }

  @override
  Future<Weather> getCurrentWeather(String city) async {
    Uri requestUri = Uri.https(
        _authority, '$_apiPath/weather', {'q': city, 'units': 'metric'});
    var jsonResponse = await _readJson(client.get(requestUri));
    return api_weather.Weather.fromCurrentWeatherResponse(city, jsonResponse);
  }

  static final String _authority = 'api.openweathermap.org';
  static final String _apiPath = 'data/2.5';

  Future<Map<String, dynamic>> _readJson(
      Future<http.Response> futureResponse) async {
    var resp = await futureResponse;
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    } else {
      var reason = resp.reasonPhrase;
      throw HttpException(resp.statusCode, reason);
    }
  }
}
