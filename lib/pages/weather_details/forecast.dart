
import 'package:flutter/material.dart';
import 'package:openweather_app/model/weather.dart';
import 'package:openweather_app/pages/weather_details/forecast_bloc.dart';
import 'package:openweather_app/widgets/temperature.dart';
import 'package:openweather_app/widgets/weather_icon.dart';
import 'package:provider/provider.dart';

class Forecast extends StatefulWidget {
  const Forecast({
    Key key,
    this.city,
  }) : super(key: key);

  final City city;

  @override
  _ForecastState createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {
  ForecastBloc _bloc;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null){
      _bloc = ForecastBloc(widget.city, Provider.of(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var primaryColor = theme.primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Text(
            'Forecast',
            style: theme.textTheme.headline5,
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ForecastData>>(
            stream: _bloc.forecast,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(alignment: Alignment.center,
                child: Text('Error while loading forecast.', style: theme.accentTextTheme.headline5.copyWith(color: theme.errorColor,),));
              } else if (!snapshot.hasData || snapshot.data == null){
                return Center(child: CircularProgressIndicator(),);
              } else {
              return ListView(
                  children: ListTile.divideTiles(
                      color: primaryColor,
                      tiles: snapshot.data.map(
                        (data) => ListTile(
                          trailing: Text(data.day),
                          title: TemperatureText(
                            temperature: data.weather.temperature,
                            height: Theme.of(context).textTheme.subtitle1.fontSize,
                          ),
                          leading: Image.asset(weatherIconForCondition(data.weather.condition)),
                        ),
                      )).toList(growable: false));
            }
            }
          ),
        ),
      ],
    );
  }
}

