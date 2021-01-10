import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Country.dart';

class OfflinePage extends StatefulWidget {
  OfflinePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  var favourite_Data = [];
  var _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    // TODO: implement initState
    GetData();
  }

  GetData() async {
    final prefs = await _prefs;
    List<String> countries = prefs.getStringList("favCountries");
    print(countries);
    favourite_Data = [];
    for (var c in countries) {
      //print(c);
      var temp = json.decode(c);
      setState(() {
        favourite_Data.add(
            Country(temp["id"], temp["code"], temp["name"], temp["region"]));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favourites"),
        ),
        body: favourite_Data.length == 0
            ? Center(
                child: Text(
                "No Favourites",
                style: TextStyle(fontSize: 30),
              ))
            : ListView.builder(
                itemCount: favourite_Data.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                    leading: Icon(
                      Icons.star_purple500_outlined,
                      color: Colors.purpleAccent,
                      size: 30,
                    ),
                    title: Text(favourite_Data[index].name +
                        " (" +
                        favourite_Data[index].code +
                        ")"),
                    subtitle: Text(favourite_Data[index].region),
                  ));
                }));
  }
}
