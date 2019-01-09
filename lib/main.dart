import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        // routes: {
        //   'new_page': (context)=>NewRoute(),
        // },
        home: MyHomePage(title: 'Flutter Demo Home Page'));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String str = "0";
  var ary = [];
  static String operator = "";

  void _number(String num) {
    setState(() {
      // show new number after pressed operator
      if (operator != "") {
        operator = "";
        str = "0";
      }

      if (str == "0") {
        str = num;
      } else {
        str += num;
      }
    });
  }

  void _operator(String oper) {
    setState(() {
      if (operator == "" || operator == "=") {
        ary.add(str);
        ary.add(oper);
        operator = oper;
      } else if (operator != oper) {
        ary.removeLast();
        ary.add(oper);
        operator = oper;
      }

      print(ary);
    });
  }

  void _evaluate() {
    setState(() {
      ary.add(str);
      print(ary);
      var postfix = infix2postfix();
      print(postfix);
      str = calculate(postfix).toString().replaceAll(new RegExp(r"\.?0+$"), "");
      if (str != "NaN") {
        operator = "=";
        ary.clear();
      }
    });
  }

  List infix2postfix() {
    var postfix = [];
    var stack = [];
    ary.forEach((elem) {
      if (priority(elem) != 0) {
        if (stack.length > 0 && priority(stack.last) >= priority(elem)) {
          postfix.add(stack.removeLast());
          stack.add(elem);
        } else {
          stack.add(elem);
        }
      } else {
        // number
        postfix.add(elem);
      }
    });
    while (stack.iterator.moveNext()) {
      postfix.add(stack.removeLast());
    }
    return postfix;
  }

  double calculate(List postfix) {
    var stack = [];
    postfix.forEach((elem) {
      if (priority(elem) != 0) {
        var num1 = stack.removeLast();
        var num2 = stack.removeLast();
        stack.add(calc(elem, num1, num2));
      } else {
        stack.add(double.tryParse(elem));
      }
    });
    return stack.removeLast();
  }

  double calc(String oper, double num1, double num2) {
    var result = 0.0;
    switch (oper) {
      case "+":
        result = num2 + num1;
        break;
      case "-":
        result = num2 - num1;
        break;
      case "X":
        result = num2 * num1;
        break;
      case "/":
        result = num2 / num1;
        break;
    }
    return result;
  }

  int priority(String operator) {
    return operator == "+" || operator == "-"
        ? 1
        : operator == "/" || operator == "X" ? 2 : 0;
  }

  var symbolBtn =
      (BuildContext context, String text, onPressed) => RawMaterialButton(
            child: Text(text, style: TextStyle(fontSize: 30)),
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.2,
                minHeight: MediaQuery.of(context).size.width * 0.2),
            fillColor: operator == text ? Colors.grey[100] : Colors.grey[400],
            highlightColor: Colors.grey[100],
            shape: new CircleBorder(),
            onPressed: onPressed,
          );
  var operatorBtn = (BuildContext context, String text, onPressed) =>
      RawMaterialButton(
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 30)),
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.2,
            minHeight: MediaQuery.of(context).size.width * 0.2),
        fillColor: Colors.orange[500],
        highlightColor: Colors.orange[100],
        shape: new CircleBorder(),
        onPressed: onPressed,
      );
  var numberBtn = (BuildContext context, String text, onPressed) =>
      RawMaterialButton(
          child:
              Text(text, style: TextStyle(color: Colors.white, fontSize: 30)),
          constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.2,
              minHeight: MediaQuery.of(context).size.width * 0.2),
          fillColor: Colors.grey[800],
          highlightColor: Colors.grey,
          shape: new CircleBorder(),
          onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.end,
        spacing: 12.0,
        runSpacing: 6.0,
        children: <Widget>[
          Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.fromLTRB(50, 100, 50, 10),
              // constraints: BoxConstraints(maxHeight: 100),
              child: Text(str.replaceAll(new RegExp(r'^\.'), "0."),
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal))),
          symbolBtn(context, (str == "0" ? "AC" : "C"), () {
            setState(() {
              if (str == "0") {
                ary.clear();
                operator = "";
              } else {
                str = "0";
              }
            });
          }),
          symbolBtn(context, "+/-", () {
            setState(() {
              var val = double.tryParse(str);
              val = val * -1;
              str = val.toString().replaceAll(new RegExp(r"\.?0+$"), "");
            });
          }),
          symbolBtn(context, "%", () {
            setState(() {
              var val = double.tryParse(str);
              val = val / 100;
              str = val.toString().replaceAll(new RegExp(r"\.?0+$"), "");
            });
          }),
          operatorBtn(context, "/", () {
            _operator("/");
          }),
          numberBtn(context, "7", () {
            _number("7");
          }),
          numberBtn(context, "8", () {
            _number("8");
          }),
          numberBtn(context, "9", () {
            _number("9");
          }),
          operatorBtn(context, "X", () {
            _operator("X");
          }),
          numberBtn(context, "4", () {
            _number("4");
          }),
          numberBtn(context, "5", () {
            _number("5");
          }),
          numberBtn(context, "6", () {
            _number("6");
          }),
          operatorBtn(context, "-", () {
            _operator("-");
          }),
          numberBtn(context, "1", () {
            _number("1");
          }),
          numberBtn(context, "2", () {
            _number("2");
          }),
          numberBtn(context, "3", () {
            _number("3");
          }),
          operatorBtn(context, "+", () {
            _operator("+");
          }),
          RawMaterialButton(
            child:
                Text("0", style: TextStyle(color: Colors.white, fontSize: 30)),
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.45,
                minHeight: MediaQuery.of(context).size.width * 0.2),
            fillColor: Colors.grey[800],
            highlightColor: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0)),
            onPressed: () {
              _number("0");
            },
          ),
          numberBtn(context, ".", () {
            _number(".");
          }),
          operatorBtn(context, "=", _evaluate),
        ],
      ),
    );
  }
}

// New Route
class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New route"),
      ),
      body: Center(
        child: Text("This is new route"),
      ),
    );
  }
}

// package test
class RandomWordsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 生成��机字符串
    final wordPair = new WordPair.random();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Text(wordPair.toString()),
    );
  }
}
