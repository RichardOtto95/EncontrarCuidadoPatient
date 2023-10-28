import 'package:encontrarCuidado/app/shared/widgets/data_tile.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class EditAddress extends StatefulWidget {
  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
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
                    'Editar endereço',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: wXD(20, context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleWidget(
                      title: 'Editar endereço de cobrança',
                    ),
                    SizedBox(
                      height: wXD(20, context),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: wXD(13, context)),
                      child: DataTile(
                        noIcon: true,
                        title: 'Endereço',
                        hint: 'Rua 123 Quadra 321 Lote 123 Número 321',
                        enabled: false,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: wXD(13, context)),
                      child: DataTile(
                        noIcon: true,
                        title: 'Distrito/Bairro',
                        hint: 'Condomínio Vila do Chaves',
                        enabled: false,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: wXD(13, context)),
                      child: DataTile(
                        noIcon: true,
                        title: 'Cidade',
                        hint: 'Asa Norte',
                        enabled: false,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: wXD(13, context)),
                      child: DataTile(
                        noIcon: true,
                        title: 'Estado',
                        hint: 'Brasília - DF',
                        enabled: false,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: wXD(13, context)),
                      child: DataTile(
                        noIcon: true,
                        title: 'CEP',
                        hint: '77.777-777',
                        enabled: false,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: wXD(20, context),
                            top: wXD(20, context),
                            right: wXD(10, context),
                            bottom: wXD(20, context),
                          ),
                          height: wXD(24, context),
                          width: wXD(24, context),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xff707070).withOpacity(.30),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xfffafafa),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                offset: Offset(2, 2),
                                color: Color(0x10000000),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Tornar este o seu endereço principal',
                          style: TextStyle(
                            fontSize: wXD(15, context),
                            color: Color(0xff707070),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: wXD(20, context),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: maxWidth * .66,
                          height: maxWidth * .125,
                          margin: EdgeInsets.only(top: maxWidth * .03),
                          alignment: Alignment.center,
                          child: Text(
                            'Concluir',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
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
                    SizedBox(
                      height: wXD(20, context),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
