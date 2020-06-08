import 'package:intl/intl.dart';
import 'package:openweather_app/model/weather.dart';
import 'package:openweather_app/services/weather_client.dart';
import 'package:rxdart/rxdart.dart';

final DateFormat _dateFormat = DateFormat.Md();

class ForecastBloc {
  final City city;
  final WeatherClient client;
  final DateTime tomorrow = DateTime.now().toUtc().add(Duration(days: 1));

  ForecastBloc(this.city, this.client) {
    forecast = Stream.fromFuture(client.get7DaysForecast(city))
        .map((forecastMap) => forecastMap.entries.map((entry) {
              DateTime date = entry.key;
              Weather weather = entry.value;

              if (tomorrow.day == date.day &&
                  tomorrow.month == date.month &&
                  tomorrow.year == date.year) {
                return ForecastData("tomorrow", weather);
              } else {
                return ForecastData(_dateFormat.format(date), weather);
              }
            }).toList(growable: false))
        .startWith(null)
        .shareValue();
  }

  Stream<List<ForecastData>> forecast;
}

class ForecastData {
  final String day;
  final Weather weather;

  ForecastData(this.day, this.weather);
}
