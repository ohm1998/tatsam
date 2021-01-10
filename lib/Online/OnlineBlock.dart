import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatsam/Country.dart';

class OnlineBlock {
  List<Country> _countryList = [];
  final _countryListStreamController = StreamController<List<Country>>();

  final _countryAddFavStreamController = StreamController<Country>();
  final _countryRemoveFavStreamController = StreamController<Country>();

  Stream<List<Country>> get countryListStream =>
      _countryListStreamController.stream;

  StreamSink<List<Country>> get countryListSink =>
      _countryListStreamController.sink;

  StreamSink<Country> get makeCountryFav => _countryAddFavStreamController.sink;

  StreamSink<Country> get RemCountryFromFav =>
      _countryRemoveFavStreamController.sink;

  OnlineBlock() {
    Dio http = Dio();
    http.get("https://api.first.org/data/v1/countries").then((res) {
      var data = res.data['data'];
      List<Country> countries = [];
      int i = 0;
      for (var c in data.keys) {
        //print(data[c]);
        countries.add(Country(i, c, data[c]['country'], data[c]['region']));
        i++;
      }
      _countryList = countries;
      _countryListStreamController.add(countries);
      _countryAddFavStreamController.stream.listen(_AddCountryToFav);
      _countryRemoveFavStreamController.stream.listen(_RemoveCountryFromFav);
    });
  }
  void _AddCountryToFav(Country c) {
    //print(c.id);
    //print(_countryList);
    _countryList[c.id].fav = true;
    countryListSink.add(_countryList);
  }

  void _RemoveCountryFromFav(Country c) {
    _countryList[c.id].fav = false;
    countryListSink.add(_countryList);
  }

  dispose() async {
    var favCountries = [];
    for (Country c in _countryList) {
      favCountries.add({c.code: c.getData()});
    }
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("favCountries", json.encode(favCountries));
    _countryAddFavStreamController.close();
    _countryListStreamController.close();
    _countryRemoveFavStreamController.close();
  }
}
