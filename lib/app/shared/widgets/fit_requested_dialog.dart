import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utilities.dart';

// ignore: must_be_immutable
class FitRequestedDialog extends StatelessWidget {
  final MainStore mainStore = Modular.get();
  final Function onConfirm, onCancel;
  final String text;
  final String appointmentId;
  bool check = false;
  bool loadCircular = false;

  FitRequestedDialog({
    Key key,
    this.onConfirm,
    this.onCancel,
    this.text = '',
    this.appointmentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        height: maxHeight(context),
        width: maxWidth(context),
        color:
            //  mainStore.fittingsList[0] != appointmentId
            //     ? Colors.transparent
            //     :
            Color(0x50000000),
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        alignment: Alignment.center,
        child: Container(
          height: wXD(320, context),
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
                  text,
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
                  'Você pretende aceitar este agendamento?',
                  style: TextStyle(
                    fontSize: wXD(15, context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xff484D54),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  left: wXD(18, context),
                  right: wXD(28, context),
                ),
                child: Row(
                  children: [
                    StatefulBuilder(builder: (context, setState) {
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () => setState(() => check = !check),
                        child: Container(
                          margin: EdgeInsets.only(right: wXD(15, context)),
                          height: wXD(22, context),
                          width: wXD(22, context),
                          decoration: BoxDecoration(
                            color:
                                check ? Color(0xff2676E1) : Color(0xfffafafa),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                color: Color(0xff707070).withOpacity(.3)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                offset: Offset(0, 3),
                                color: Color(0x30000000),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.check_rounded,
                            color: Color(0xfffafafa),
                            size: wXD(15, context),
                          ),
                        ),
                      );
                    }),
                    Container(
                        width: wXD(240, context),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff4c4c4c),
                                fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(text: '* Eu aceito os '),
                              TextSpan(
                                text: 'termos e condições',
                                style: TextStyle(
                                    color: Color(0xff41C3B3),
                                    decorationColor: Color(0xff41C3B3),
                                    decoration: TextDecoration.underline),
                              ),
                              TextSpan(text: ', e a '),
                              TextSpan(
                                text: 'política de privacidade ',
                                style: TextStyle(
                                    color: Color(0xff41C3B3),
                                    decorationColor: Color(0xff41C3B3),
                                    decoration: TextDecoration.underline),
                              ),
                              TextSpan(
                                  text:
                                      'da EncontrarCuidado. E estou ciente da caução de 30% que será cobrada ao aceitar a confirmação.'),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Spacer(),
              StatefulBuilder(
                builder: (context, setState) {
                  return loadCircular
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
                              onTap: () async {
                                setState(() {
                                  loadCircular = true;
                                });
                                await onCancel();

                                setState(() {
                                  loadCircular = false;
                                });
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
                              onTap: () async {
                                if (!check) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Confirme que está ciente da caução e concorda com os termos de uso e a política de privacidade");
                                } else {
                                  // setState(() async {
                                  //   loadCircular = true;
                                  //   await onConfirm();
                                  //   loadCircular = false;
                                  // });

                                  setState(() {
                                    loadCircular = true;
                                  });
                                  await onConfirm();

                                  setState(() {
                                    loadCircular = false;
                                  });
                                }
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
