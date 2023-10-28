import 'package:flutter/material.dart';

import '../utilities.dart';

class DependentTile extends StatelessWidget {
  final String name;
  final Function onTap;

  const DependentTile({Key key, this.name, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: wXD(26, context),
        width: wXD(310, context),
        child: Text(
          '$name',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Color(0xff4c4c4c), fontSize: 18, height: 1.5),
        ),
      ),
    );
  }
}
