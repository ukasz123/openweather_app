import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> _initialCities = const [
  'Gdańsk',
  'Warszawa',
  'Kraków',
  'Wrocław',
  'Łódź'
];

const String _kCities = 'cities';

class CitiesListBloc {
  SharedPreferences _prefs;

  Stream<List<String>> get cities => _citiesSubject;

  final BehaviorSubject<List<String>> _citiesSubject = BehaviorSubject();

  CitiesListBloc() {
    _loadCities();
  }

  Future<void> _loadCities() async {
    _prefs = await SharedPreferences.getInstance();
    List<String> cachedCities = _prefs.getStringList(_kCities);
    if (cachedCities == null) {
      cachedCities = _initialCities.toList();
      await _prefs.setStringList(_kCities, cachedCities);
    }
    _citiesSubject.add(cachedCities);
  }

  void addCity(String cityName) {
    var name = cityName?.trim() ?? "";
    if (name.isNotEmpty) {
    List<String> currentList = List.of(_citiesSubject.value);
    if (!currentList.contains(cityName)) {
      currentList.add(cityName);
      _citiesSubject.add(currentList);
      _prefs.setStringList(_kCities, currentList);
    }
    }
  }

  void dispose() {
    _citiesSubject.close();
  }
}
