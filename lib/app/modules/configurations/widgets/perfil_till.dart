import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class PerfilTill extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const PerfilTill({Key key, this.icon, this.title, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: maxWidth,
        height: maxHeight * 41 / 375,
        child: Row(children: [
          Container(
            padding: EdgeInsets.only(
              top: maxHeight * 1 / 375,
              left: maxWidth * 1 / 375,
            ),
            child: Icon(
              icon,
              size: wXD(29, context),
              color: Color(0xff707070).withOpacity(.9),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: maxHeight * 1 / 375, left: maxWidth * 13 / 375),
            child: Text(
              '$title',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Color(0xff707070).withOpacity(.9),
                fontSize: wXD(19, context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            size: wXD(20, context),
            color: Color(0xff707070).withOpacity(.5),
          ),
        ]),
        margin: EdgeInsets.symmetric(horizontal: maxWidth * 26 / 375),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0x40707070),
            ),
          ),
        ),
      ),
    );
  }
}
