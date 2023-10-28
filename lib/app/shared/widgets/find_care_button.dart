import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class EncontrarCuidadoButton extends StatelessWidget {
  final String title;
  final double top;
  final double bottom;
  final double height;
  final double width;
  final Function onTap;

  const EncontrarCuidadoButton({
    Key key,
    this.title,
    this.top = 10,
    this.bottom = 15,
    this.height = 39,
    this.width = 163,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;
    return StatefulBuilder(builder: (context, setState) {
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            loadCircular = true;
          });
          onTap();
        },
        child: Center(
          child: Container(
            margin: EdgeInsets.only(
              top: wXD(top, context),
              bottom: wXD(bottom, context),
            ),
            height: wXD(height, context),
            width: wXD(width, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
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
              ],
            ),
            alignment: Alignment.center,
            child: loadCircular
                ? CircularProgressIndicator()
                : Text(
                    '$title',
                    style: TextStyle(
                      color: Color(0xfffafafa),
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
