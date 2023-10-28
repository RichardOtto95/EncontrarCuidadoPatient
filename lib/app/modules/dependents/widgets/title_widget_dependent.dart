import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class TitleWidgetDependent extends StatelessWidget {
  final String title;

  const TitleWidgetDependent({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        wXD(26, context),
        wXD(13, context),
        wXD(0, context),
        wXD(4, context),
      ),
      child: Text(
        '$title',
        style: TextStyle(
            color: Color(0xff41C3B3),
            fontSize: wXD(20, context),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
