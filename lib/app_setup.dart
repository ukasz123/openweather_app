import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:objectdb/objectdb.dart';
import 'package:openweather_app/api_keys.dart';
import 'package:openweather_app/services/openweather/client.dart';
import 'package:openweather_app/services/openweather/http.dart';
import 'package:openweather_app/services/repository/weather_repository.dart';
import 'package:openweather_app/services/weather_client.dart';
import 'package:path_provider/path_provider.dart';
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
        FutureProvider<ObjectDB>(
          lazy: false,
          create: (_) async {
            var appDocsDirectory = await getApplicationDocumentsDirectory();
            var cacheFile = File([appDocsDirectory.path, 'cache.db'].join('/'));

            var objectDB = ObjectDB(cacheFile.path);
            await objectDB.open();
            return objectDB;
          },
        ),

        // repository
        ProxyProvider2<OpenWeatherClient, ObjectDB, WeatherRepository>(
            update: (_, remoteClient, database, previous) =>
                WeatherRepository(remoteClient, database),
                dispose: (_, repo) => repo.close(),),
              
        // return repository as a WeatherClient
        ProxyProvider<WeatherRepository, WeatherClient>(
          update: (_, repo, __) => repo,
        ),
      ],
      child: Consumer<ObjectDB>(builder: (context, db, _){
        if (db == null){
          // awaits until all database objects are initialized
          return MaterialApp(
                      home: Scaffold(
                        body: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text('Initializing...'),
                            LinearProgressIndicator(),
                          ],),
                        ),
            ),
          );
        } else {
          return child;
        }
      })
    );
  }
}
