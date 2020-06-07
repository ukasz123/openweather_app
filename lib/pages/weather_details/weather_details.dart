import 'dart:math';

import 'package:flutter/material.dart';
import 'package:openweather_app/model/weather.dart';
import 'package:openweather_app/pages/weather_details/forecast.dart';
import 'package:openweather_app/utils/temperature_color.dart';
import 'package:openweather_app/widgets/temperature.dart';
import 'package:openweather_app/widgets/temperature_theme.dart';
import 'package:openweather_app/widgets/weather_icon.dart';

class CityWeatherPage extends StatelessWidget {
  final Weather currentWeather;

  const CityWeatherPage({
    Key key,
    this.currentWeather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tempColor = forTemperature(currentWeather.temperature);
    return PrimaryThemeBuilder(
      color: tempColor,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('7 days forecast'),
          elevation: 0,
        ),
        body: OrientationBuilder(
          builder: (_, orientation) => (orientation == Orientation.portrait)
              ? Column(
                  children: [
                    SizedBox(
                        height: 260.0,
                        child: _CurrentWeather(currentWeather: currentWeather)),
                    Expanded(
                      child: Forecast(city: currentWeather.city),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        child: _CurrentWeather(currentWeather: currentWeather)),
                    Expanded(
                      child: Forecast(city: currentWeather.city),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _CurrentWeather extends StatelessWidget {
  const _CurrentWeather({
    Key key,
    @required this.currentWeather,
  }) : super(key: key);

  final Weather currentWeather;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).primaryTextTheme;
    var bgColor = Theme.of(context).primaryColor;
    return Hero(
      tag: 'weatherCard:${currentWeather.city.name}',
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          color: bgColor,
          margin: EdgeInsets.all(0),
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      currentWeather.city.name,
                      style: textTheme.headline4,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          weatherIconForCondition(currentWeather.condition),
                          width: 80,
                          color: textTheme.bodyText1.color,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TemperatureText(
                              temperature: currentWeather.temperature,
                              height: 32,
                              textStyle: textTheme.bodyText1,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pressure (hPa)',
                              style: textTheme.subtitle2,
                            ),
                            Text(
                              '${currentWeather.pressure.toStringAsFixed(1)}',
                              style: textTheme.subtitle1,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Humidity (%)',
                              style: textTheme.subtitle2,
                            ),
                            Text(
                              '${currentWeather.humidity.toStringAsFixed(1)}',
                              style: textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}
