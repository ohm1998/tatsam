import 'package:flutter/material.dart';

class OfflinePage extends StatefulWidget {
  OfflinePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offline Page"),
      ),
      body: Center(
        child: Text("Hello from Offline Page"),
      ),
    );
  }
}
