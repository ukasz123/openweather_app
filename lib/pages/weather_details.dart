import 'dart:math';

import 'package:flutter/material.dart';
import 'package:openweather_app/utils/temperature_color.dart';
import 'package:openweather_app/widgets/temperature.dart';
import 'package:openweather_app/widgets/temperature_theme.dart';
import 'package:openweather_app/widgets/weather_icon.dart';

class CityWeatherPage extends StatelessWidget {
  final String city;
  final double temperature;
  final String weatherType;

  const CityWeatherPage(
      {Key key, this.city, this.temperature, this.weatherType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tempColor = forTemperature(temperature);
    return PrimaryThemeBuilder(
      color: tempColor,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('7 days forecast'),
          elevation: 0,
        ),
        body: Column(
          children: [
            Hero(
              tag: 'weatherCard:$city',
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  color: tempColor,
                  margin: EdgeInsets.all(0),
                  child: Container(
                      height: 280.0,
                      padding: const EdgeInsets.all(24),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              city,
                              style:
                                  Theme.of(context).primaryTextTheme.headline4,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  weatherType,
                                  width: 80,
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1
                                      .color,
                                ),
                                TemperatureText(
                                  temperature: temperature,
                                  height: 32,
                                  textStyle: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))),
            ),
            Expanded(
              child: ListView(
                  children: ListTile.divideTiles(
                      color: tempColor,
                      tiles: forecast.map(
                        (day) => ListTile(
                          trailing: Text(day),
                          title: TemperatureText(
                            temperature: (_r.nextDouble() * 40) - 9.0,
                            height:
                                Theme.of(context).textTheme.subtitle1.fontSize,
                          ),
                          leading: Image.asset(_weathers[_r.nextInt(5)]),
                        ),
                      )).toList(growable: false)),
            )
          ],
        ),
      ),
    );
  }
}

Random _r = Random();

List<String> forecast = [
  "tomorrow",
  "2.04",
  "3.04",
  "4.04",
  "5.04",
  "6.04",
  "7.04",
];

const List<String> _weathers = const [
  WeatherIcons.cloudSunny,
  WeatherIcons.rain,
  WeatherIcons.sunny,
  WeatherIcons.snowHeavy,
  WeatherIcons.rainLight,
];
