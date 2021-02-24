import 'package:flutter/material.dart';

class Converter extends StatefulWidget {
  @override
  _ConverterState createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 30.0;
  double resultFontSize = 40.0;

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
      } else if (buttonText == "km -> miles") {
        var res = double.parse(equation);
        res = res * 0.6214;
        var stringResult = res.toStringAsFixed(2);
        result = stringResult;
      } else if (buttonText == "miles -> km") {
        var res = double.parse(equation);
        res = res / 0.6214;
        var stringResult = res.toStringAsFixed(2);
        result = stringResult;
      } else if (buttonText == "=") {
        equationFontSize = 30.0;
        resultFontSize = 40.0;
        expression = equation;
      } else {
        equationFontSize = 40.0;
        resultFontSize = 30.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
      if (buttonText == "km -> miles") {
        var result = double.parse(equation);
        result = result * 0.6214;
        var stringResult = result.toString();
        expression = stringResult;
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
                    color: Colors.white, width: 1, style: BorderStyle.solid)),
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
            Container(
              child: RaisedButton(
                  onPressed: () => buttonPressed("km to miles"),
                  child: Text("km -> miles"),
                  color: Colors.blue),
            ),
            Container(
              child: RaisedButton(
                  onPressed: () => buttonPressed("miles to km"),
                  child: Text("miles -> km"),
                  color: Colors.blue),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * .75,
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildButton("C", 1, Colors.red),
                        buildButton("⌫", 1, Colors.red),
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
            ])
          ],
        ));
  }
}