import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SetCards extends StatefulWidget {
  const SetCards({
    Key key,
  }) : super(key: key);
  @override
  _SetCardsState createState() => _SetCardsState();
}

class _SetCardsState extends State<SetCards> {
  final MainStore mainStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Visibility(
        visible: mainStore.setCards,
        child: AnimatedContainer(
          height: maxHeight(context),
          width: maxWidth(context),
          color: !mainStore.setCards ? Colors.transparent : Color(0x50000000),
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: wXD(15, context)),
              height: wXD(215, context),
              width: wXD(324, context),
              decoration: BoxDecoration(
                  color: Color(0xfffafafa),
                  borderRadius: BorderRadius.all(Radius.circular(33))),
              child: Column(
                children: [
                  Container(
                    width: wXD(290, context),
                    margin: EdgeInsets.only(top: wXD(15, context)),
                    child: Text(
                      'Para realizar seu primeiro agendamento, é necessário adicionar um cartão em Perfil > Pagamentos > Adicionar Cartão. Deseja navegar para esta seção?',
                      style: TextStyle(
                        fontSize: wXD(15, context),
                        fontWeight: FontWeight.w600,
                        color: Color(0xfa707070),
                      ),
                      textAlign: TextAlign.justify,
                      // textAlign: TextAlign.start,
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  mainStore.loadCircularSetCards
                      ? Row(
                          children: [
                            Spacer(),
                            CircularProgressIndicator(),
                            Spacer(),
                          ],
                        )
                      : Row(
                          children: [
                            Spacer(),
                            InkWell(
                              onTap: () {
                                mainStore.setCards = false;
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
                                await mainStore.setLoadCircularSetCards(true);

                                await Modular.to.pushNamed('/payment/add-card',
                                    arguments: false);
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
                        ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
