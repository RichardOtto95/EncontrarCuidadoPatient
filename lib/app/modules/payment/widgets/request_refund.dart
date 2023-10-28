import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/confirmation.dart';
import 'package:encontrarCuidado/app/shared/widgets/doctor_note.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/info_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../payment_store.dart';

class RequestRefund extends StatefulWidget {
  final String id;
  final String drID;

  const RequestRefund({Key key, this.id, this.drID}) : super(key: key);
  @override
  _RequestRefundState createState() => _RequestRefundState();
}

class _RequestRefundState extends State<RequestRefund> {
  final PaymentStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EncontrarCuidadoNavBar(
              leading: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: wXD(11, context), right: wXD(11, context)),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: maxWidth(context) * 26 / 375,
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  Text(
                    'Solicitar reembolso',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: wXD(20, context),
                    ),
                  ),
                ],
              ),
            ),
            InfoText(
              color: Color(0xff4c4c4c),
              left: 18,
              top: 25,
              size: 17,
              title: 'Informações adicionais para o doutor (opcional)',
            ),
            DoctorNote(
              onChanged: (txt) {
                store.setRefundNote(txt);
              },
              text:
                  'Indique qualquer informação que você gostaria de compartilhar com o doutor para a solicitação de reembolso',
            ),
            Spacer(
              flex: 4,
            ),
            Observer(builder: (context) {
              return Center(
                child: store.refundCircular
                    ? CircularProgressIndicator()
                    : InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          String status =
                              await store.requestRefund(widget.id, widget.drID);
                          store.refundNote = '';
                          print(
                              '%%%%%%%%%%%%%%%% status $status %%%%%%%%%%%%%%%%');
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ConfirmRefund(
                                routerPayment: true,
                                noAvatar: false,
                                title: status == 'PENDING_REFUND'
                                    ? 'Reembolso programado com sucesso!'
                                    : 'Solicitação de reembolso\nenviada com sucesso!',
                                subTitle: status == 'PENDING_REFUND'
                                    ? 'A consulta referente à essa transação foi cancelada. O reembolso pode ser feito em até 3 dias úteis.'
                                    : 'Para esta solicitação ser concluída,\ndeverá ser aprovada pelo especialista.',
                              );
                            },
                          ));
                        },
                        child: Container(
                          width: wXD(240, context),
                          height: wXD(47, context),
                          // margin: EdgeInsets.only(top: maxWidth * .03),
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
                            borderRadius: BorderRadius.all(Radius.circular(19)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff41C3B3),
                                Color(0xff21BCCE),
                              ],
                            ),
                          ),
                        ),
                      ),
              );
            }),
            Spacer()
          ],
        ),
      ),
    );
  }
}
