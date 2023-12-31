import 'package:flutter/material.dart';

import '../utilities.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final TextStyle style;
  final double left;
  final double top;
  final double right;
  final double bottom;

  const TitleWidget({
    Key key,
    this.title,
    this.style,
    this.left = 21,
    this.top = 10,
    this.right = 0,
    this.bottom = 7,
  }) : super(key: key);

  TextStyle getStyle(BuildContext context) {
    TextStyle _style;
    if (style == null) {
      _style = TextStyle(color: Color(0xff4C4C4C), fontSize: 19);
    } else {
      _style = style;
    }
    return _style;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        wXD(left, context),
        wXD(top, context),
        wXD(right, context),
        wXD(bottom, context),
      ),
      child: Text(
        '$title',
        style: getStyle(context),
      ),
    );
  }
}
