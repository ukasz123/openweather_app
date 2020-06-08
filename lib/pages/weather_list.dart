import 'package:flutter/material.dart';
import 'package:objectdb/objectdb.dart';
import 'package:openweather_app/pages/weather_list/add_city_card.dart';
import 'package:openweather_app/pages/weather_list/cities_list_bloc.dart';
import 'package:openweather_app/pages/weather_list/city_weather_card.dart';
import 'package:openweather_app/pages/weather_list/force_refresh_bloc.dart';
import 'package:provider/provider.dart';

class WeatherListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return MultiProvider(
      providers: [
          Provider<CitiesListBloc>(
            create: (_) => CitiesListBloc(),
            dispose: (_, bloc) => bloc.dispose(),
          ),
          ProxyProvider<ObjectDB, ForceRefreshBloc>(
            update: (_, cacheDB, __) => ForceRefreshBloc(cacheDB),
            dispose: (_, bloc) => bloc.dispose(),),],
          child: Builder(
                      builder:(context) => Scaffold(
        appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            textTheme: theme.textTheme,
            title: Text('Weather today'),
            elevation: 0,
            actions: [
              IconButton(icon: Icon(Icons.refresh, color: theme.textTheme.button.color), onPressed: Provider.of<ForceRefreshBloc>(context, listen: false).forceRefresh),
            ],
        ),
        body: LayoutBuilder(
            builder: (context, constraints) {
              var crossAxisCount = (constraints.maxWidth / 180).floor();
              return Consumer<CitiesListBloc>(
                  builder: (context, bloc, _) => StreamBuilder<List<String>>(
                      stream: bloc.cities,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GridView(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount),
                            children: [...snapshot.data
                                .map((city) => CityWeatherCard(city: city))
                                .toList(),
                                AddCityCard(onCityNameEntered: bloc.addCity,),
                                ],
                          );
                        } else {
                          return Container();
                        }
                      }));
            },
        ),
      ),
          ),
    );
  }
}
