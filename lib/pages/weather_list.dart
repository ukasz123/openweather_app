
import 'package:flutter/material.dart';
import 'package:openweather_app/pages/weather_list/city_weather_card.dart';

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
