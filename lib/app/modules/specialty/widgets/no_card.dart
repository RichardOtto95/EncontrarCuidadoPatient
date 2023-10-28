import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/payment/widgets/add_card.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NoCard extends StatefulWidget {
  const NoCard({
    Key key,
  }) : super(key: key);

  @override
  _NoCardState createState() => _NoCardState();
}

class _NoCardState extends State<NoCard> {
  final MainStore mainStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EncontrarCuidadoNavBar(
                leading: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: wXD(11, context), right: wXD(11, context)),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          size: maxWidth * 26 / 375,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    Text(
                      'Pagamento',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: wXD(20, context),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: wXD(3, context)),
              TitleWidget(title: 'Adicione um cartão'),
              Container(
                // margin: EdgeInsets.only(bottom: wXD(2, context)),
                // decoration: BoxDecoration(
                //   color: Color(0xfffafafa),
                //   boxShadow: [
                //     BoxShadow(
                //       color: const Color(0x29000000),
                //       offset: Offset(0, 3),
                //       blurRadius: 3,
                //     ),
                //   ],
                //   borderRadius: BorderRadius.vertical(
                //     bottom: Radius.circular(25),
                //   ),
                // ),
                height: wXD(270, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: wXD(53, context), bottom: wXD(44, context)),
                      child: Image.asset('assets/img/Imagemsemcartão.jpeg'),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          // Modular.to.pushNamed('/payment');

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AddCard(
                                        hasCard: false,
                                      )));
                        },
                        child: Container(
                          width: maxWidth * .66,
                          height: maxWidth * .1,
                          margin: EdgeInsets.only(top: maxWidth * .03),
                          alignment: Alignment.center,
                          child: Text(
                            'Adicionar cartão',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(23)),
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
                    ),
                    // SizedBox(
                    //   height: wXD(50, context),
                    // ),
                  ],
                ),
              ),
              Center(
                  child: Container(
                margin: EdgeInsets.only(top: wXD(20, context)),
                width: wXD(280, context),
                child: Text(
                  'Adicionar um cartão antes de prosseguir com o agendamento!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff707070).withOpacity(.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
