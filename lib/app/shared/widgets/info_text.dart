import 'package:flutter/material.dart';

import '../utilities.dart';

class InfoText extends StatelessWidget {
  final String title;
  final double size;
  final double left;
  final double right;
  final double top;
  final double height;
  final Color color;
  final FontWeight weight;

  const InfoText({
    Key key,
    this.title,
    this.size = 15,
    this.left = 40,
    this.right = 20,
    this.top = 10,
    this.height = 1,
    this.color = const Color(0xff707070),
    this.weight,
  }) : super(key: key);

  getWeight() {
    FontWeight _weight;
    if (weight == null) {
      _weight = FontWeight.w400;
    } else {
      _weight = weight;
    }
    return _weight;
  }

  @override
  Widget build(BuildContext context) {
    Color _color;

    if (color == null) {
      _color = Color(0xff707070);
    } else {
      _color = color;
    }
    return Container(
      width: wXD(375, context),
      padding: EdgeInsets.only(
        left: wXD(left, context),
        right: wXD(right, context),
        top: wXD(top, context),
      ),
      child: Text(
        '$title',
        style: TextStyle(
          height: height,
          color: _color,
          fontWeight: getWeight(),
          fontSize: size,
        ),
      ),
    );
  }
}
