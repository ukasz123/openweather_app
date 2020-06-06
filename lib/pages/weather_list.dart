import 'dart:math';

import 'package:flutter/material.dart';
import 'package:openweather_app/pages/weather_details.dart';
import 'package:openweather_app/utils/temperature_color.dart';
import 'package:openweather_app/widgets/temperature.dart';
import 'package:openweather_app/widgets/temperature_theme.dart';
import 'package:openweather_app/widgets/weather_icon.dart';

class WeatherListPage extends StatelessWidget {
  static List<String> cities = const [
    'Gdańsk',
    'Warszawa',
    'Kraków',
    'Wrocław',
    'Łódź'
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        textTheme: theme.textTheme,
        title: Text('Weather today'),
        elevation: 0,
      ),
      body: GridView(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: cities.map((city) => CityWeatherCard(city: city)).toList(),
      ),
    );
  }
}

final _rand = Random();

class CityWeatherCard extends StatelessWidget {
  final String city;

  final double temperature = ((_rand.nextDouble() * 40.0)) - 9.0;

  static List<String> _weathers = const [
    WeatherIcons.cloudSunny,
    WeatherIcons.rain,
    WeatherIcons.sunny,
    WeatherIcons.snowHeavy,
    WeatherIcons.rainLight,
  ];
  final String weatherType = _weathers[_rand.nextInt(5)];

  CityWeatherCard({Key key, this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tempColor = forTemperature(temperature);
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CityWeatherPage(
                temperature: this.temperature,
                city: this.city,
                weatherType: this.weatherType,
              ))),
      child: PrimaryThemeBuilder(
        color: tempColor,
        builder: (context) => Hero(
          tag: 'weatherCard:$city',
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: tempColor,
              margin: EdgeInsets.all(4.0),
              child: Container(
                  height: 200.0,
                  padding: const EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(1, 0.8),
                        child: Text(
                          city,
                          style: Theme.of(context).primaryTextTheme.headline5,
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
                              width: 64,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .color,
                            ),
                            TemperatureText(
                                textStyle: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1,
                                temperature: temperature,
                                height: 22),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }
}
