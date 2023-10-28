import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class ProfileTill extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool bottomBorder;
  final Function onTap;
  final String index;

  const ProfileTill({
    Key key,
    this.icon,
    this.title,
    this.onTap,
    this.bottomBorder = true,
    this.index = '',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: maxWidth,
            height: hXD(60, context),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: wXD(1, context), left: wXD(12, context)),
                  child: Icon(
                    icon,
                    size: wXD(29, context),
                    color: Color(0xff707070).withOpacity(.8),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: maxWidth * 1 / 375, left: maxWidth * 5 / 375),
                  child: Text(
                    '$title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xff707070),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: wXD(23, context),
                  color: Color(0x90707070),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: maxWidth * 15 / 375),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: bottomBorder ? Color(0x40707070) : Colors.transparent,
                ),
              ),
            ),
          ),
          index != ''
              ? Positioned(
                  left: wXD(40, context),
                  top: wXD(10, context),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: wXD(17, context),
                    width: wXD(17, context),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red),
                    child: Text(
                      '$index',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
