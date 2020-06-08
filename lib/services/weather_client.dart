import 'package:openweather_app/model/weather.dart';

//Generic client interface - used for repository and remote client implementations
abstract class WeatherClient {
  Future<Weather> getCurrentWeather(String city, {bool forceRefresh: false});

  Future<Map<DateTime, Weather>> get7DaysForecast(City city);
}
