import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class DependentTile extends StatelessWidget {
  final String text;
  final Function onTap;

  const DependentTile({
    Key key,
    this.text,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.only(
          top: wXD(20, context),
          bottom: wXD(15, context),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: wXD(28, context),
        ),
        child: Row(
          children: [
            Text(
              '$text',
              style: TextStyle(
                fontSize: wXD(19, context),
                color: Color(0xff707070),
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: wXD(15, context),
              color: Color(0x80707070),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0x40707070),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
