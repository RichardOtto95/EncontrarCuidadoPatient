import 'package:flutter/material.dart';

import '../utilities.dart';

class DialogNotification extends StatelessWidget {
  final String text;
  final double bottom;
  final Function onClose;
  const DialogNotification(
      {Key key, this.text, this.bottom = 118, this.onClose})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClose,
      child: Container(
        padding: EdgeInsets.only(bottom: wXD(bottom, context)),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: wXD(311, context),
              height: wXD(47, context),
              padding: EdgeInsets.symmetric(horizontal: wXD(21, context)),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 6,
                      offset: Offset(0, 4)),
                ],
                borderRadius: BorderRadius.all(Radius.circular(7)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff41c3b3),
                    Color(0xff21bcce),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$text',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Color(0xfffafafa),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto'),
                  ),
                  Text(
                    'Fechar',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Color(0xfffafafa),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
