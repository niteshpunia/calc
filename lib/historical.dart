import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Historical extends StatefulWidget {
  @override
  _HistoricalState createState() => _HistoricalState();
}

class _HistoricalState extends State<Historical> {
  List historyList = [];

  @override
  void initState() {
    getHistory();
  }

  getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> loadedList = prefs.getStringList("History");

    print(loadedList);
    setState(() {
      historyList = loadedList.map((item) => json.decode(item)).toList();
      print("Historical data");
      print(historyList);
    });
  }

  Widget myItems() {
    return Column(
      children: historyList.map((item) => Text(item.toString())).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('My Calc')),
        body: Column(
          children: <Widget>[
            Text("History",
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.yellow)),
            myItems()
          ],
        ));
  }
}
