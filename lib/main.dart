import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'home_screen.dart';

void main() => runApp(new MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: new Color(0xffee613a),
        accentColor: new Color(0xffe04d25),
      ),
      home: new MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );
    animation =
        new Tween<double>(begin: 100.0, end: 300.0).animate(animationController)
          ..addListener(() {
            setState(() {});
          });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      color: Colors.red,
      child: new Container(
        width: animation.value,
        height: animation.value,
        color: Colors.black,
      ),
    );
  }
}
