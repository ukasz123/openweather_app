class WeatherIcons {
  WeatherIcons._();
  static const String _prefix = 'assets/icons/weather/';
  static const String _suffix = '.png';

  static const String sunny = '${_prefix}sunny$_suffix';
  static const String sunnyCloud = '${_prefix}cloudy-sun$_suffix';
  static const String cloudSunny = '${_prefix}cloud-sunny$_suffix';
  static const String cloudy = '${_prefix}cloudy$_suffix';
  static const String cloudyFog = '${_prefix}cloudy-fog$_suffix';

  static const String rain = '${_prefix}rainy$_suffix';
  static const String rainLight = '${_prefix}drizzle-rain$_suffix';
  static const String rainHeavy = '${_prefix}heavy-rain$_suffix';

  static const String cloudyThunderbolt =
      '${_prefix}cloudy-storm-thunderbolt$_suffix';
  static const String storm = '${_prefix}storm$_suffix';

  static const String snow = '${_prefix}cloudy-snow$_suffix';
  static const String snowHeavy = '${_prefix}heavy-snow$_suffix';
  static const String snowLight = '${_prefix}cloud-light-snow$_suffix';
}
