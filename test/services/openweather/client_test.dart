import 'package:flutter_test/flutter_test.dart';
import 'package:openweather_app/api_keys.dart';
import 'package:openweather_app/model/weather.dart';
import 'package:openweather_app/services/openweather/client.dart';
import 'package:openweather_app/services/openweather/http.dart';

void main() {
  test(
      'Open Weather current weather API call should return successful response',
      () async {
    OpenWeatherClient client = OpenWeatherClient(
        httpClient: OpenWeatherHttpClient(OPEN_WEATHER_API_KEY));
    var response = await client.getCurrentWeather('Katowice');
    expect(response, isNotNull);
    expect(response.city.name, equals('Katowice'));
    expect(response.condition, isNotNull);
    expect(response.temperature, isNotNull);
    expect(response.humidity, isNotNull);
    expect(response.pressure, isNotNull);
  });

  test(
      'Open Weather 7 days forecast API call should return successful response',
      () async {
    OpenWeatherClient client = OpenWeatherClient(
        httpClient: OpenWeatherHttpClient(OPEN_WEATHER_API_KEY));
    var response =
        await client.get7DaysForecast(City('Szczecin', 53.4298189, 14.4845402));
    var today = DateTime.now().toUtc();
    var tomorrow = DateTime.now().toUtc().add(Duration(days: 1));
    expect(response, isNotNull);
    expect(response.keys.length, equals(7));
    expect(response.values.length, equals(7));
    expect(response.keys.first.weekday, equals(tomorrow.weekday));
    expect(response.keys.last.weekday, equals(today.weekday));
  });
}
