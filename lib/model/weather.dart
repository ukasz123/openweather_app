abstract class Weather {
  final double temperature;
  final City city;
  final WeatherCondition condition;
  // In hPa
  final double pressure;
  // Percent
  final double humidity;

  Weather(this.temperature, this.city, this.condition, this.pressure, this.humidity);
}

enum WeatherCondition {
  sunny,
  sunnyCloud,
  cloudySun,
  cloudy,
  fog,
  rain,
  rainLight,
  rainHeavy,
  storm,

  snow,
  snowLight,
  snowHeavy
}

class City {
  final String name;
  final double lat;
  final double long;

  City(this.name, this.lat, this.long);
}