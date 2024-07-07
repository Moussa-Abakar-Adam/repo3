import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        num1 = 0.0;
        num2 = 0.0;
        operand = "";
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "*" ||
          buttonText == "/") {
        num1 = double.parse(_output);
        operand = buttonText;
        _output = "0";
      } else if (buttonText == ".") {
        if (!_output.contains(".")) {
          _output += buttonText;
        }
      } else if (buttonText == "=") {
        num2 = double.parse(_output);
        switch (operand) {
          case "+":
            _output = (num1 + num2).toString();
            break;
          case "-":
            _output = (num1 - num2).toString();
            break;
          case "*":
            _output = (num1 * num2).toString();
            break;
          case "/":
            _output = (num1 / num2).toString();
            break;
        }
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
        }
        num1 = 0.0;
        num2 = 0.0;
        operand = "";
      } else {
        if (_output == "0") {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            backgroundColor: color,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () => buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              buildButton("7", Colors.blue[900]!),
              buildButton("8", Colors.blue[900]!),
              buildButton("9", Colors.blue[900]!),
              buildButton("/", Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("4", Colors.blue[900]!),
              buildButton("5", Colors.blue[900]!),
              buildButton("6", Colors.blue[900]!),
              buildButton("*", Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("1", Colors.blue[900]!),
              buildButton("2", Colors.blue[900]!),
              buildButton("3", Colors.blue[900]!),
              buildButton("-", Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton(".", Colors.blue[900]!),
              buildButton("0", Colors.blue[900]!),
              buildButton("C", Colors.red),
              buildButton("+", Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("=", Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}
