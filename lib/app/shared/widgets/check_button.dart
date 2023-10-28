import 'package:flutter/material.dart';

import '../utilities.dart';

class CheckButton extends StatelessWidget {
  const CheckButton({Key key, this.onTap}) : super(key: key);
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            bottom: 5,
          ),
          height: maxWidth(context) * .1493,
          width: maxWidth(context) * .1493,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff41C3B3),
                  Color(0xff21BCCE),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(0, 3),
                  color: Color(0x30000000),
                )
              ]),
          child: Icon(
            Icons.check,
            color: Color(0xfffafafa),
            size: maxWidth(context) * .1,
          ),
        ),
      ),
    );
  }
}
