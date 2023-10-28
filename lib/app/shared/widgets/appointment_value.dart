import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utilities.dart';

class AppointmentValue extends StatelessWidget {
  final double price;
  final bool schedulingReturn;

  const AppointmentValue({
    Key key,
    this.price,
    this.schedulingReturn = false,
  }) : super(key: key);

  String formatedCurrency(var value) {
    var newValue = new NumberFormat("#,##0.00", "pt_BR");
    return newValue.format(value);
  }

  Widget build(context) {
    double _price;
    if (schedulingReturn) {
      _price = 0;
    } else {
      _price = price;
    }
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: wXD(30, context)),
        padding: EdgeInsets.symmetric(horizontal: wXD(15, context)),
        width: wXD(340, context),
        height: wXD(50, context),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff41c3b3)),
            borderRadius: BorderRadius.all(Radius.circular(13))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Valor total da consulta',
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'R\$ ${formatedCurrency(_price)}',
              style: TextStyle(
                color: Color(0xff41c3b3),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
