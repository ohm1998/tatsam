import 'package:flutter/material.dart';
import 'package:tatsam/Offline/OfflineView.dart';
import 'package:tatsam/Online/OnlineView.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _curr_page = 0;
  var widget_list = [OnlinePage(), OfflinePage()];
  void _setIndex(index) {
    print(index);
    setState(() {
      _curr_page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.online_prediction), title: Text("Online")),
            BottomNavigationBarItem(
                icon: Icon(Icons.offline_bolt), title: Text("Offline"))
          ],
          onTap: _setIndex,
          showSelectedLabels: true,
          currentIndex: _curr_page,
          selectedItemColor: Colors.red,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          unselectedItemColor: Colors.black,
          elevation: 10.0,
        ),
        body: widget_list[_curr_page]);
  }
}
