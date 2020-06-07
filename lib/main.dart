import 'package:flutter/material.dart';
import 'package:openweather_app/app_setup.dart';
import 'package:openweather_app/pages/weather_list.dart';

void main() {
  runApp(AppDependenciesSetup(child: WeatherApp()));
}

class WeatherApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      theme: ThemeData(
        primaryColor: Colors.green.shade700,
        accentColor: Colors.amberAccent.shade400,
        indicatorColor: Colors.green.shade500 ,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeatherListPage(),
    );
  }
}
