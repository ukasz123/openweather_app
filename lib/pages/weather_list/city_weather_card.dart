import 'dart:math';

import 'package:flutter/material.dart';
import 'package:openweather_app/model/weather.dart';
import 'package:openweather_app/pages/weather_details.dart';
import 'package:openweather_app/pages/weather_list/city_weather_bloc.dart';
import 'package:openweather_app/utils/temperature_color.dart';
import 'package:openweather_app/widgets/temperature.dart';
import 'package:openweather_app/widgets/temperature_theme.dart';
import 'package:openweather_app/widgets/weather_icon.dart';
import 'package:provider/provider.dart';

class CityWeatherCard extends StatefulWidget {
  final String city;

  CityWeatherCard({Key key, this.city}) : super(key: key);

  @override
  _CityWeatherCardState createState() => _CityWeatherCardState();
}

class _CityWeatherCardState extends State<CityWeatherCard> {
  CityWeatherBloc _bloc;

  static const Color _loadingColor = Color(0xff666666);
  static const Color _errorColor = Color(0xff770000);

  @override
  void didUpdateWidget(CityWeatherCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_bloc == null || oldWidget.city != widget.city) {
      _initBloc();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _initBloc();
    }
  }

  void _initBloc() {
    // TODO attach refresh stream
    _bloc = CityWeatherBloc(
        cityName: widget.city,
        client: Provider.of(context),
        refreshRequest: Stream.empty());
  }

  @override
  Widget build(BuildContext context) {
    String cityName = widget.city;
    if (_bloc == null) {
      return Container();
    }
    return StreamBuilder<Weather>(
        stream: _bloc.currentWeather,
        builder: (context, snapshot) {
          Color cardColor;
          Widget conditions;
          VoidCallback onTap;
          if (snapshot.hasError) {
            cardColor = _errorColor;
            conditions = _WeatherError(error: snapshot.error);
          } else if (!snapshot.hasData || snapshot.data == null) {
            cardColor = _loadingColor;
            conditions = _WeatherLoading();
          } else {
            var weather = snapshot.data;
            cardColor = forTemperature(weather.temperature);
            var type = _typeForConditions(weather.condition);
            conditions = _WeatherCardConditions(
                weatherType: _typeForConditions(weather.condition),
                temperature: weather.temperature);
            onTap = () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => CityWeatherPage(
                      temperature: weather.temperature,
                      city: this.widget.city,
                      weatherType: type,
                    )));
          }
          return InkWell(
            onTap: onTap,
            child: PrimaryThemeBuilder(
              color: cardColor,
              builder: (context) => _WeatherCardLayout(
                  cityName: cityName, conditions: conditions),
            ),
          );
        });
  }
}

class _WeatherError extends StatelessWidget {
  final Object error;
  const _WeatherError({
    Key key,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).primaryTextTheme.bodyText1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.error,
          size: 36,
          color: textStyle.color,
        ),
        SizedBox(height: 4.0),
        Text(
          'Error while loading data',
          style: textStyle,
        ),
      ],
    );
  }
}

class _WeatherLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 56.0,
          height: 56.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text('Loading...',
              textAlign: TextAlign.right,
              style: theme.primaryTextTheme.bodyText2),
        ),
      ],
    );
  }
}

String _typeForConditions(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.snow:
      return WeatherIcons.snow;
    case WeatherCondition.snowHeavy:
      return WeatherIcons.snowHeavy;
    case WeatherCondition.snowLight:
      return WeatherIcons.snowLight;
    case WeatherCondition.sunny:
      return WeatherIcons.sunny;
    case WeatherCondition.sunnyCloud:
      return WeatherIcons.sunnyCloud;
    case WeatherCondition.cloudySun:
      return WeatherIcons.cloudSunny;
    case WeatherCondition.cloudy:
      return WeatherIcons.cloudy;
    case WeatherCondition.fog:
      return WeatherIcons.cloudyFog;
    case WeatherCondition.rain:
      return WeatherIcons.rain;
    case WeatherCondition.rainHeavy:
      return WeatherIcons.rainHeavy;
    case WeatherCondition.rainLight:
      return WeatherIcons.rainLight;
    case WeatherCondition.storm:
      return WeatherIcons.storm;
    default:
      return null;
  }
}

class _WeatherCardLayout extends StatelessWidget {
  const _WeatherCardLayout({
    Key key,
    @required this.cityName,
    @required this.conditions,
  }) : super(key: key);

  final String cityName;
  final Widget conditions;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Hero(
      tag: 'weatherCard:$cityName',
      child: Card(
          color: theme.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.all(4.0),
          child: Container(
              height: 200.0,
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(1, 0.8),
                    child: Text(
                      cityName,
                      style: theme.primaryTextTheme.headline5,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: conditions,
                  ),
                ],
              ))),
    );
  }
}

class _WeatherCardConditions extends StatelessWidget {
  const _WeatherCardConditions({
    Key key,
    @required this.weatherType,
    @required this.temperature,
  }) : super(key: key);

  final String weatherType;
  final double temperature;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          weatherType,
          width: 64,
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
        TemperatureText(
            textStyle: Theme.of(context).primaryTextTheme.bodyText1,
            temperature: temperature,
            height: 22),
      ],
    );
  }
}
