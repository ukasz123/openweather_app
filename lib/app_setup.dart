import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:openweather_app/api_keys.dart';
import 'package:openweather_app/services/openweather/client.dart';
import 'package:openweather_app/services/openweather/http.dart';
import 'package:openweather_app/services/repository/weather_repository.dart';
import 'package:openweather_app/services/weather_client.dart';
import 'package:provider/provider.dart';

class AppDependenciesSetup extends StatelessWidget {
  final Widget child;
  const AppDependenciesSetup({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Client>(
            create: (_) => OpenWeatherHttpClient(OPEN_WEATHER_API_KEY)),
        // remote API client
        ProxyProvider<Client, OpenWeatherClient>(
            update: (_, client, previous) =>
                previous ?? OpenWeatherClient(httpClient: client)),
        // repository
        ProxyProvider<OpenWeatherClient, WeatherRepository>(
            update: (_, remoteClient, previous) =>
                previous ?? WeatherRepository(remoteClient)),
        // return repository as a WeatherClient
        ProxyProvider<WeatherRepository, WeatherClient>(
          update: (_, repo, __) => repo,
        )
      ],
      child: child,
    );
  }
}
