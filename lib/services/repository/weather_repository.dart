import 'package:objectdb/objectdb.dart';
import 'package:openweather_app/model/weather.dart';
import 'package:openweather_app/services/weather_client.dart';

class WeatherRepository implements WeatherClient {
  final WeatherClient remoteServiceClient;
  final ObjectDB database;

  WeatherRepository(this.remoteServiceClient, this.database);

  @override
  Future<Map<DateTime, Weather>> get7DaysForecast(City city) async {
    var query = {'city': city.name};
    Map<String, dynamic> weatherData = await database.first(query);
    Map<String, dynamic> cachedForecast = weatherData['forecast'];
    if (cachedForecast != null) {
      return cachedForecast.map((key, value) => MapEntry(
          DateTime.parse(key),
          _weatherFromMap(value as Map<String, dynamic>)));
    } else {
      var remoteData = await remoteServiceClient.get7DaysForecast(city);
      cachedForecast = remoteData.map(
          (key, value) => MapEntry(key.toIso8601String(), value.toMap()));
      await database.update(query, {'forecast': cachedForecast});
      return remoteData;
    }
  }

  @override
  Future<Weather> getCurrentWeather(String city,
      {bool forceRefresh: false}) async {
    var refresh = forceRefresh;
    Map<String, dynamic> weatherData;
    if (!refresh) {
      weatherData = await database.first({'city': city});
      if (weatherData == null) {
        refresh = true;
      } else {
        var now = DateTime.now();
        var lastUpdate =
            DateTime.fromMillisecondsSinceEpoch(weatherData['timestamp']);
        if (now.difference(lastUpdate).inHours > 2) {
          refresh = true;
        }
      }
    }
    if (refresh) {
      var remoteData = await remoteServiceClient.getCurrentWeather(city,
          forceRefresh: forceRefresh);
      var isUpdate = weatherData != null;
      weatherData = {
        'city': city,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'currentWeather': remoteData.toMap(),
      };
      if (isUpdate) {
        await database.update({'city': city}, weatherData, true);
      } else {
        await database.insert(weatherData);
      }
      return remoteData;
    } else {
      return _weatherFromMap(
          weatherData['currentWeather'] as Map<String, dynamic>);
    }
  }

  void close() {
    database?.tidy();
  }
}

extension _CityDatabaseExtension on City {
  Map<String, dynamic> toMap() => {
        "name": name,
        "lat": lat,
        "lon": long,
      };
}

City _cityFromMap(Map<String, dynamic> map) =>
    City(map['name'], (map['lat'] as num).toDouble(), (map['lon'] as num).toDouble());

extension _WeatherDatabaseExtension on Weather {
  Map<String, dynamic> toMap() => {
        'city': city.toMap(),
        'temperature': temperature,
        'humidity': humidity,
        'pressure': pressure,
        'condition': condition.index,
      };
}

Weather _weatherFromMap(Map<String, dynamic> map) => _WeatherDB(
      (map['temperature'] as num).toDouble(),
      _cityFromMap(map['city'] as Map<String, dynamic>),
      WeatherCondition.values[map['condition']],
      (map['pressure'] as num).toDouble(),
      (map['humidity'] as num).toDouble(),
    );

class _WeatherDB extends Weather {
  _WeatherDB(double temperature, City city, WeatherCondition condition,
      double pressure, double humidity)
      : super(temperature, city, condition, pressure, humidity);
}
