import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/payment/widgets/request_refund.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../payment_store.dart';

class TransactionDetail extends StatefulWidget {
  final String id;
  final String consultation;
  final String txt;
  final String amount;
  final String drID;
  final Timestamp date;
  final bool revert;

  const TransactionDetail({
    Key key,
    this.id,
    this.consultation,
    this.txt,
    this.amount,
    this.date,
    this.revert,
    this.drID,
  }) : super(key: key);
  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  final MainStore mainStore = Modular.get();
  final PaymentStore store = Modular.get();

  @override
  void initState() {
    store.getCanRefound(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: wXD(50, context)),
                  width: maxWidth,
                  height: wXD(150, context),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          color: Color(0x40000000),
                          offset: Offset(0, 3))
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff41C3B3),
                        Color(0xff21BCCE),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(28)),
                  ),
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          wXD(0, context),
                          wXD(18, context),
                          wXD(18, context),
                          wXD(15, context),
                        ),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            size: wXD(35, context),
                            color: Color(0xfffafafa),
                          ),
                        ),
                      ),
                      Center(
                        child: TitleWidget(
                          title: 'Detalhes da transação',
                          left: 0,
                          top: 0,
                          style: TextStyle(
                            color: Color(0xfffafafa),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    margin: EdgeInsets.only(right: wXD(8, context)),
                    padding: EdgeInsets.all(wXD(5, context)),
                    height: wXD(80, context),
                    width: wXD(80, context),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Color(0xfffafafa)),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff707070), width: 1),
                        // color: Color(0xff707070),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.monetization_on,
                          color: Color(0xff707070),
                          size: wXD(45, context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: wXD(190, context),
              child: Text(
                'Operação realizada em ${DateFormat("${'dd'} '\de' ${'MMMM'} '-' ${'HH:mm'}", "pt_BR").format(DateTime.fromMillisecondsSinceEpoch(widget.date.millisecondsSinceEpoch))}',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xff787C81).withOpacity(.7),
                  fontSize: wXD(17, context),
                ),
              ),
            ),
            Spacer(flex: 1),
            Container(
              width: wXD(300, context),
              child: Center(
                child: Text(
                  '${widget.txt}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontWeight: FontWeight.bold,
                    fontSize: wXD(20, context),
                  ),
                ),
              ),
            ),
            Spacer(flex: 1),
            Text(
              'R\$ ${widget.amount}',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.bold,
                fontSize: wXD(25, context),
              ),
            ),
            Visibility(
              visible: widget.revert,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: wXD(15, context),
                      color: Color(0xffFBBD08),
                    ),
                    SizedBox(
                      width: wXD(5, context),
                    ),
                    Container(
                      width: wXD(140, context),
                      child: Text(
                        'Reembolso solicitado',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color(0xff787C81).withOpacity(.7),
                          fontSize: wXD(12, context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Observer(builder: (context) {
              return Visibility(
                visible: store.canRefund,
                child: Center(
                  child: Observer(builder: (context) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return RequestRefund(
                              id: widget.id,
                              drID: widget.drID,
                            );
                          },
                        ));
                      },
                      child: Container(
                        width: wXD(240, context),
                        height: wXD(39, context),
                        margin: EdgeInsets.only(top: maxWidth * .03),
                        alignment: Alignment.center,
                        child: Text(
                          'Solicitar reembolso',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 6,
                                color: Color(0x50000000))
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(23)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: store.canRefund
                                ? [
                                    Color(0xff41C3B3),
                                    Color(0xff21BCCE),
                                  ]
                                : [
                                    Colors.grey,
                                    Colors.grey,
                                  ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
            Spacer(
              flex: 1,
            ),
            Row(
              children: [
                Spacer(),
                Text(
                  '''Precisa de ajuda? Solicte ao
suporte.''',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color(0xff787C81).withOpacity(.7),
                    fontSize: 17,
                  ),
                ),
                Spacer(),
                Container(
                  // duration: Duration(seconds: 1),
                  // curve: Curves.decelerate,
                  height: maxWidth * 58 / 375,
                  width: maxWidth * 58 / 375,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff41C3B3),
                          Color(0xff21BCCE),
                        ]),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 3,
                        color: Color(0x20000000),
                      )
                    ],
                    borderRadius: BorderRadius.circular(90),
                    border: Border.all(
                      width: 2,
                      color: Color(0xfffafafa),
                    ),
                  ),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await mainStore.setSupportChat();
                      Modular.to.pushNamed('/suport/');
                    },
                    child: Icon(
                      Icons.headset_mic,
                      color: Color(0xfffafafa),
                      size: maxWidth * .08,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
