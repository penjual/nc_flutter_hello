import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class TabIndicator extends StatefulWidget {
  final Size screenSize;
  final bool action;

  TabIndicator({Key key, @required this.screenSize, this.action})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _TabIndicatorState();
  }
}

class _TabIndicatorState extends State<TabIndicator>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> dxTargetAnim;
  Animation<double> dxEntryAnim;

  Size screenSize;
  double iconSize;
  double height;
  double section;
  double horizontalPadding;

  @override
  void initState() {
    super.initState();
    screenSize = widget.screenSize;
    iconSize = 47.0;
    height = 70.0;
    section = screenSize.width / 8;
    horizontalPadding = section - iconSize / 2;

    animationController = new AnimationController(
      duration: new Duration(milliseconds: 1000),
      vsync: this,
    );
    setUpAnimation(0, 1);
    animationController
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TabIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.action) actionAnim();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: const Color(0xffee613a),
      child: new CustomPaint(
        size: new Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
        painter: new _TabIndicationPainter(
          dxTarget: dxTargetAnim.value,
          dxEntry: dxEntryAnim.value,
          dy: height / 2,
          radius: iconSize / 2,
        ),
        child: indicatorIcon(),
      ),
    );
  }

  void actionAnim() {
    animationController.forward();
  }

  void setUpAnimation(int fromIndex, int toIndex) {
    dxTargetAnim = new Tween<double>(
            begin: section * (fromIndex * 2 + 1),
            end: section * (toIndex * 2 + 1))
        .animate(intervalCurved(0.0, 1.0));
    dxEntryAnim = new Tween<double>(
            begin: section * (fromIndex * 2 + 1),
            end: section * (toIndex * 2 + 1))
        .animate(intervalCurved(0.5, 1.0));
  }

  CurvedAnimation intervalCurved(begin, end, [curve = Curves.easeInOut]) {
    return new CurvedAnimation(
      parent: animationController,
      curve: new Interval(begin, end, curve: curve),
    );
  }

  Widget indicatorIcon() {
    return new Container(
      width: screenSize.width,
      height: height,
      padding: new EdgeInsets.symmetric(
        vertical: height / 2 - iconSize / 2,
      ),
      child: new Stack(
        children: <Widget>[
          getIcon(0, 'images/which_icon_1.png'),
          getLine(0),
          getIcon(1, 'images/how_icon_1.png'),
          getLine(1),
          getIcon(2, 'images/where_icon_1.png'),
          getLine(2),
          getIcon(3, 'images/when_icon_1.png'),
        ],
      ),
    );
  }

  Widget getIcon(index, image) {
    return new Positioned(
      left: section * (index * 2 + 1) - iconSize / 2,
      child: new Container(
        width: 47.0,
        height: 47.0,
        alignment: Alignment.center,
        child: new Image.asset(image),
      ),
    );
  }

  Widget getLine(index) {
    return new Positioned(
      top: iconSize / 2,
      left: section * (index * 2 + 1) + iconSize / 2,
      child: new Image.asset(
        'images/indicator_connect.png',
        width: section * 2 - iconSize,
        height: 0.7,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}

class _TabIndicationPainter extends CustomPainter {
  Paint painter;
  final double dxTarget;
  final double dxEntry;
  final double radius;
  final double dy;

  _TabIndicationPainter(
      {this.dxTarget = 200.0,
      this.dxEntry = 50.0,
      this.radius = 25.0,
      this.dy = 25.0}) {
    painter = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset entry = new Offset(dxEntry, dy);
    Offset target = new Offset(dxTarget, dy);

    Path path = new Path();
    path.addArc(
        new Rect.fromCircle(center: entry, radius: radius), 0.5 * PI, 1 * PI);
    path.addRect(
        new Rect.fromLTRB(entry.dx, dy - radius, target.dx, dy + radius));
    path.addArc(
        new Rect.fromCircle(center: target, radius: radius), 1.5 * PI, 1 * PI);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(_TabIndicationPainter oldDelegate) => true;
}
