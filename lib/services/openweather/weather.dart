class City {
  final String name;
  final double lat;
  final double long;

  City(this.name, this.lat, this.long);
}

class Weather {
  final double temperature;
  final City city;
  final WeatherCondition condition;
  // In hPa
  final double pressure;
  // Percent
  final double humidity;

  Weather._(this.temperature, this.city, this.condition, this.pressure,
      this.humidity);

  factory Weather.fromCurrentWeatherResponse(Map<String, dynamic> json) {
    Map<String, dynamic> mainData = json['main'];
    double temperature = (mainData['temp'] as num).toDouble();
    double pressure = (mainData['pressure'] as num).toDouble();
    double humidity = (mainData['humidity'] as num).toDouble();
    String name = json['name'];
    Map<String, dynamic> coords = json['coord'];
    double lat = coords['lat'];
    double long = coords['long'];
    String conditionIcon = ((json['weather'] as List<dynamic>).first
        as Map<String, dynamic>)['icon'];
    WeatherCondition condition = _fromIconCode(conditionIcon);
    return Weather._(
        temperature, City(name, lat, long), condition, pressure, humidity);
  }

  factory Weather.fromForecastResponse(City city, Map<String, dynamic> json) {
    double temperature = (json['temp'] as Map<String, dynamic>)['day'];

    double pressure = (json['pressure'] as num).toDouble();
    double humidity = (json['humidity'] as num).toDouble();
    String conditionIcon = ((json['weather'] as List<dynamic>).first
        as Map<String, dynamic>)['icon'];
    WeatherCondition condition = _fromIconCode(conditionIcon);
    return Weather._(temperature, city, condition, pressure, humidity);
  }

  @override
  String toString() {
    return "Weather for ${city.name}: $condition, temperature: $temperature C, pressure: $pressure hPA, humidity: $humidity%";
  }
}

WeatherCondition _fromIconCode(String conditionIcon) {
  String code = conditionIcon.substring(0, 2);
  switch (code) {
    case "01":
      return WeatherCondition.sunny;
    case "02":
      return WeatherCondition.sunnyCloud;
    case "03":
      return WeatherCondition.cloudySun;
    case "04":
      return WeatherCondition.cloudy;
    case "09":
      return WeatherCondition.rainHeavy;
    case "10":
      return WeatherCondition.rain;
    case "11":
      return WeatherCondition.storm;
    case "13":
      return WeatherCondition.snow;
    case "50":
      return WeatherCondition.fog;
    default:
      return null;
  }
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
