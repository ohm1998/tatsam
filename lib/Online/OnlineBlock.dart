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
  final _prefs = SharedPreferences.getInstance();
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
      GetData();
    });
  }
  GetData() async {
    final prefs = await _prefs;
    List<String> countries = prefs.getStringList("favCountries");
    for (var c in countries) {
      //print(c);
      var temp = json.decode(c);
      makeCountryFav
          .add(Country(temp["id"], temp["code"], temp["name"], temp["region"]));
    }
  }

  _UpdatePreferences() async {
    List<String> favCountries = [];
    for (Country c in _countryList) {
      if (c.fav) {
        favCountries.add(json.encode(c.getData()));
      }
    }
    var prefs = await SharedPreferences.getInstance();
    //print(favCountries);
    prefs.setStringList("favCountries", favCountries);
  }

  void _AddCountryToFav(Country c) {
    //print(c.id);
    //print(_countryList);
    _countryList[c.id].fav = true;
    countryListSink.add(_countryList);
    _UpdatePreferences();
  }

  void _RemoveCountryFromFav(Country c) {
    _countryList[c.id].fav = false;
    countryListSink.add(_countryList);
    _UpdatePreferences();
  }

  dispose() async {
    _countryAddFavStreamController.close();
    _countryListStreamController.close();
    _countryRemoveFavStreamController.close();
  }
}
