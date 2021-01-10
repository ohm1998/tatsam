import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatsam/Online/OnlineBlock.dart';

import '../Country.dart';

class OnlinePage extends StatefulWidget {
  OnlinePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OnlinePageState createState() => _OnlinePageState();
}

class _OnlinePageState extends State<OnlinePage> {
  final onlineBlock = new OnlineBlock();
  var _prefs = SharedPreferences.getInstance();
  var favCountries = [];
  @override
  void initState() {
    print("Init Online");
    GetData();
  }

  GetData() async {
    final prefs = await _prefs;
    List<String> countries = prefs.getStringList("favCountries");
    for (var c in countries) {
      print(c);
      var temp = json.decode(c);
      onlineBlock.makeCountryFav
          .add(Country(temp["id"], temp["code"], temp["name"], temp["region"]));
    }
  }

  dispose() {
    onlineBlock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Online Page"),
        ),
        body: Container(
          child: StreamBuilder<List<Country>>(
            stream: onlineBlock.countryListStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Country>> snapshot) {
              if (snapshot.hasError) {
                return Text("Check Internet Connection");
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      //print(snapshot.data[index].code);
                      return Card(
                          child: ListTile(
                        leading: InkWell(
                            onTap: () {
                              //print(snapshot.data[index].name);
                              if (snapshot.data[index].fav) {
                                onlineBlock.RemCountryFromFav.add(
                                    snapshot.data[index]);
                              } else {
                                onlineBlock.makeCountryFav
                                    .add(snapshot.data[index]);
                              }
                            },
                            child: snapshot.data[index].fav
                                ? Icon(
                                    Icons.star_purple500_outlined,
                                    color: Colors.purpleAccent,
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.star_border,
                                    size: 30,
                                  )),
                        title: Text(snapshot.data[index].code +
                            " " +
                            snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].region),
                      ));
                    });
              }
              return Text("Loading");
            },
          ),
        ));
  }
}
