import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/payment/widgets/transaction_detail.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Historic extends StatelessWidget {
  final num value;
  final String date;
  final String text;
  final Function ontap;
  final DocumentSnapshot tr;
  final String description;

  const Historic({
    Key key,
    this.value,
    this.date,
    this.text = 'Transferência Clínica...',
    this.ontap,
    this.tr,
    this.description,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => TransactionDetail(
              drID: tr.get('receiver_id'),
              id: tr.get('id'),
              txt: description,
              consultation: tr.get('appointment_id'),
              date: tr.get('updated_at'),
              revert: tr.get('status') == 'REFUND_REQUESTED_INCOMEs',
              amount: formatedCurrency(tr.get('value'), tr.get('status')),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xff707070).withOpacity(.3)))),
        padding: EdgeInsets.only(bottom: wXD(5, context)),
        margin: EdgeInsets.fromLTRB(
          wXD(22, context),
          wXD(2, context),
          wXD(22, context),
          wXD(8, context),
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: wXD(8, context)),
              padding: EdgeInsets.all(wXD(5, context)),
              height: wXD(32, context),
              width: wXD(32, context),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color(0xff707070), width: wXD(1, context)),
                borderRadius: BorderRadius.circular(90),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff707070),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Center(
                  child: Icon(
                    Icons.attach_money,
                    color: Color(0xfffafafa),
                    size: 20,
                  ),
                ),
              ),
            ),
            Container(
              width: wXD(210, context),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff707070),
                ),
                maxLines: 2,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: wXD(15, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ' R\$ ${formatedCurrency(value, tr.get('status'))}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff707070),
                    ),
                  ),
                  SizedBox(
                    height: wXD(3, context),
                  ),
                  Text(
                    '$date',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0x85787C81),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

String formatedCurrency(var val, String status) {
  if (val != null) {
    num value = 0;
    if (status != 'REFUND') {
      value = val * -1;
    } else {
      value = val;
    }
    print('xxxxxxxx value $status, $value');
    var newValue = new NumberFormat("#,##0.00", "pt_BR");
    return newValue.format(value);
  } else {
    return 'Vazio';
  }
}
