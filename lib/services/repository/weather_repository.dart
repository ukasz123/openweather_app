import 'package:openweather_app/model/weather.dart';
import 'package:openweather_app/services/weather_client.dart';

class WeatherRepository implements WeatherClient {
  final WeatherClient remoteServiceClient;

  WeatherRepository(this.remoteServiceClient);

  @override
  Future<Map<DateTime, Weather>> get7DaysForecast(City city) {
    return remoteServiceClient.get7DaysForecast(city);
  }

  @override
  Future<Weather> getCurrentWeather(String city, {bool forceRefresh: false}) {
    return remoteServiceClient.getCurrentWeather(city,
        forceRefresh: forceRefresh);
  }
}
