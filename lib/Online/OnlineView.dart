import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tatsam/Online/OnlineBlock.dart';

import '../Country.dart';

class OnlinePage extends StatefulWidget {
  OnlinePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OnlinePageState createState() => _OnlinePageState();
}

class _OnlinePageState extends State<OnlinePage> {
  var onlineBlock = new OnlineBlock();
  var favCountries = [];
  var connection = true;
  @override
  initState() {
    checkConectivity();
  }

  checkConectivity() {
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        setState(() {
          connection = true;
        });
      } else {
        setState(() {
          connection = false;
        });
      }
    });
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
          child: connection
              ? StreamBuilder<List<Country>>(
                  stream: onlineBlock.countryListStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Country>> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        "Stream Error",
                        style: TextStyle(fontSize: 30),
                      ));
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
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
                              title: Text(snapshot.data[index].name +
                                  " (" +
                                  snapshot.data[index].code +
                                  ")"),
                              subtitle: Text(snapshot.data[index].region),
                            ));
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              : Center(
                  child: Text(
                  "No Internet",
                  style: TextStyle(fontSize: 30),
                )),
        ));
  }
}
