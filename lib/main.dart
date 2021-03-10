import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'converter.dart';
import 'historical.dart';
import 'package:gson/gson.dart';


void main() {
  runApp(Calc());
}

class Calc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Calc',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SimpleCalc(),
    );
  }
}

class SimpleCalc extends StatefulWidget {
  @override
  _SimpleCalcState createState() => _SimpleCalcState();
}

class _SimpleCalcState extends State<SimpleCalc> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 30.0;
  double resultFontSize = 40.0;
  Map<String, dynamic> history = {};
  List historyList2 = [];

  setHistorical() async {
    print("historical");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    
    List<String> loadedList = prefs.getStringList("history");
    print("loaded list");
    print(loadedList);
    setState(() {
      historyList2 = loadedList.map((item) => json.decode(item)).toList();
    });

    historyList2.add(history);
    List<String> list = historyList2.map((item) => json.encode(item)).toList();
    print("new history");
    print(list);
    prefs.setStringList("history", list);
  }

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 30.0;
        resultFontSize = 40.0;
      } else if (buttonText == "⌫") {
        equationFontSize = 40.0;
        resultFontSize = 30.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        equationFontSize = 30.0;
        resultFontSize = 40.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          history = {
            "equation": "$expression=$result",
            "timestamp": DateTime.now().toString()
          };
          setHistory();
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 40.0;
        resultFontSize = 30.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
        color: buttonColor,
        child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
                side: BorderSide(
                    color: Colors.grey, width: 1, style: BorderStyle.solid)),
            padding: EdgeInsets.all(16.0),
            onPressed: () => buttonPressed(buttonText),
            child: Text(buttonText,
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('My Calc')),
        body: Column(
          children: <Widget>[
            Container(
              child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Converter()),
                    );
                  },
                  child: Text("Converter"),
                  color: Colors.blue ),
            ),
            Container(
              child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => History()),
                    );
                  },
                  child: Text("Historical data"),
                  color: Colors.red),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child:
                  Text(equation, style: TextStyle(fontSize: equationFontSize)),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text(result, style: TextStyle(fontSize: resultFontSize)),
            ),
            Expanded(
              child: Divider(),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * .75,
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildButton("C", 1, Colors.red),
                        buildButton("⌫", 1, Colors.red),
                        buildButton("÷", 1, Colors.white),
                      ]),
                      TableRow(children: [
                        buildButton("7", 1, Colors.grey),
                        buildButton("8", 1, Colors.grey),
                        buildButton("9", 1, Colors.grey),
                      ]),
                      TableRow(children: [
                        buildButton("4", 1, Colors.grey),
                        buildButton("5", 1, Colors.grey),
                        buildButton("6", 1, Colors.grey),
                      ]),
                      TableRow(children: [
                        buildButton("1", 1, Colors.grey),
                        buildButton("2", 1, Colors.grey),
                        buildButton("3", 1, Colors.grey),
                      ]),
                      TableRow(children: [
                        buildButton(".", 1, Colors.grey),
                        buildButton("0", 1, Colors.grey),
                        buildButton("00", 1, Colors.grey),
                      ]),
                    ],
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("×", 1, Colors.white),
                    ]),
                    TableRow(children: [
                      buildButton("-", 1, Colors.white),
                    ]),
                    TableRow(children: [
                      buildButton("+", 1, Colors.white),
                    ]),
                    TableRow(children: [
                      buildButton("^", 1, Colors.white),
                    ]),
                    TableRow(children: [
                      buildButton("=", 1, Colors.green),
                    ]),
                  ],
                ),
              )
            ])
          ],
        ));
  }
}
