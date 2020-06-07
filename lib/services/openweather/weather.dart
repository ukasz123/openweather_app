import 'package:openweather_app/model/weather.dart' as model;

class Weather extends model.Weather {
  Weather._(double temperature, model.City city,
      model.WeatherCondition condition, double pressure, double humidity)
      : super(temperature, city, condition, pressure, humidity);

  factory Weather.fromCurrentWeatherResponse(
      String cityName, Map<String, dynamic> json) {
    Map<String, dynamic> mainData = json['main'];
    double temperature = (mainData['temp'] as num).toDouble();
    double pressure = (mainData['pressure'] as num).toDouble();
    double humidity = (mainData['humidity'] as num).toDouble();
    Map<String, dynamic> coords = json['coord'];
    double lat = coords['lat'];
    double long = coords['long'];
    String conditionIcon = ((json['weather'] as List<dynamic>).first
        as Map<String, dynamic>)['icon'];
    model.WeatherCondition condition = _fromIconCode(conditionIcon);
    return Weather._(temperature, model.City(cityName, lat, long), condition,
        pressure, humidity);
  }

  factory Weather.fromForecastResponse(
      model.City city, Map<String, dynamic> json) {
    double temperature = (json['temp'] as Map<String, dynamic>)['day'];

    double pressure = (json['pressure'] as num).toDouble();
    double humidity = (json['humidity'] as num).toDouble();
    String conditionIcon = ((json['weather'] as List<dynamic>).first
        as Map<String, dynamic>)['icon'];
    model.WeatherCondition condition = _fromIconCode(conditionIcon);
    return Weather._(temperature, city, condition, pressure, humidity);
  }

  @override
  String toString() {
    return "Weather for ${city.name}: $condition, temperature: $temperature C, pressure: $pressure hPA, humidity: $humidity%";
  }
}

model.WeatherCondition _fromIconCode(String conditionIcon) {
  String code = conditionIcon.substring(0, 2);
  switch (code) {
    case "01":
      return model.WeatherCondition.sunny;
    case "02":
      return model.WeatherCondition.sunnyCloud;
    case "03":
      return model.WeatherCondition.cloudySun;
    case "04":
      return model.WeatherCondition.cloudy;
    case "09":
      return model.WeatherCondition.rainHeavy;
    case "10":
      return model.WeatherCondition.rain;
    case "11":
      return model.WeatherCondition.storm;
    case "13":
      return model.WeatherCondition.snow;
    case "50":
      return model.WeatherCondition.fog;
    default:
      return null;
  }
}
