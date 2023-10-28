import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PopUpReschedule extends StatefulWidget {
  final bool visible;
  final Function onConfirm, onCancel;
  final String text, question;
  final MainStore mainStore;

  const PopUpReschedule({
    Key key,
    this.visible,
    this.onConfirm,
    this.onCancel,
    this.text = '',
    this.question,
    this.mainStore,
  }) : super(key: key);

  @override
  _PopUpRescheduleState createState() => _PopUpRescheduleState();
}

class _PopUpRescheduleState extends State<PopUpReschedule> {
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: AnimatedContainer(
        height: maxHeight(context),
        width: maxWidth(context),
        color: Color(0x50000000),
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        alignment: Alignment.center,
        child: Container(
          height: wXD(250, context),
          width: wXD(324, context),
          decoration: BoxDecoration(
              color: Color(0xfffafafa),
              borderRadius: BorderRadius.all(Radius.circular(28))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: wXD(17, context)),
                alignment: Alignment.center,
                child: Text(
                  'Atenção',
                  style: TextStyle(
                    fontSize: wXD(15, context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xff484D54),
                  ),
                ),
              ),
              Container(
                width: wXD(290, context),
                margin: EdgeInsets.only(top: wXD(15, context)),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: wXD(16, context),
                    fontWeight: FontWeight.w300,
                    color: Color(0xff484D54),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                width: wXD(290, context),
                margin: EdgeInsets.only(top: wXD(15, context)),
                child: Text(
                  widget.question,
                  style: TextStyle(
                    fontSize: wXD(15, context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xff484D54),
                  ),
                ),
              ),
              Spacer(),
              Observer(
                builder: (context) {
                  return widget.mainStore.loadCircularReschedule
                      ? Row(
                          children: [
                            Spacer(),
                            Container(
                                height: wXD(47, context),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator()),
                            Spacer()
                          ],
                        )
                      : Row(
                          children: [
                            Spacer(),
                            InkWell(
                              onTap: () {
                                widget.onCancel();
                              },
                              child: Container(
                                height: wXD(47, context),
                                width: wXD(98, context),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 3),
                                          blurRadius: 3,
                                          color: Color(0x28000000))
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(17)),
                                    border:
                                        Border.all(color: Color(0x80707070)),
                                    color: Color(0xfffafafa)),
                                alignment: Alignment.center,
                                child: Text(
                                  'Não',
                                  style: TextStyle(
                                      color: Color(0xff2185D0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: wXD(16, context)),
                                ),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                widget.onConfirm();
                              },
                              child: Container(
                                height: wXD(47, context),
                                width: wXD(98, context),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 3),
                                          blurRadius: 3,
                                          color: Color(0x28000000))
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(17)),
                                    border:
                                        Border.all(color: Color(0x80707070)),
                                    color: Color(0xfffafafa)),
                                alignment: Alignment.center,
                                child: Text(
                                  'Sim',
                                  style: TextStyle(
                                      color: Color(0xff2185D0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: wXD(16, context)),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        );
                },
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
