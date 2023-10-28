import 'package:encontrarCuidado/app/modules/address/widgets/add_address.dart';
import 'package:encontrarCuidado/app/modules/address/widgets/address.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
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
                    'Endereço de cobrança',
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
                      title: 'Todos os endereços',
                    ),
                    Container(
                      padding: EdgeInsets.only(left: wXD(20, context)),
                      child: Text(
                        'Adicione um novo endereço, faça edições rápidas ou remova um endereço antigo',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: wXD(14, context),
                          color: Color(0xff4c4c4c).withOpacity(.75),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: wXD(17, context),
                        horizontal: wXD(20, context),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddAddress())),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: wXD(25, context),
                              color: Color(0xff2185D0),
                            ),
                            TitleWidget(
                              left: wXD(5, context),
                              title: 'Adicionar novo',
                              style: TextStyle(
                                color: Color(0xff2185D0),
                                fontSize: wXD(19, context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: wXD(20, context)),
                      height: 1,
                      decoration: BoxDecoration(
                        color: Color(0x70707070),
                      ),
                    ),
                    Address(
                      principal: true,
                      address:
                          'Rua 123 Quadra 321 Lote 123 Número 321 Condominio Vila do Chaves',
                      city: 'Asa Norte',
                      state: 'Brasilia - DF',
                      cep: '77.777-777',
                    ),
                    Address(
                      address:
                          'Rua 123 Quadra 321 Lote 123 Número 321 Condominio Vila do Chaves',
                      city: 'Asa Norte',
                      state: 'Brasilia - DF',
                      cep: '77.777-777',
                    ),
                    Address(
                      address:
                          'Rua 123 Quadra 321 Lote 123 Número 321 Condominio Vila do Chaves',
                      city: 'Asa Norte',
                      state: 'Brasilia - DF',
                      cep: '77.777-777',
                    ),
                    Address(
                      address:
                          'Rua 123 Quadra 321 Lote 123 Número 321 Condominio Vila do Chaves',
                      city: 'Asa Norte',
                      state: 'Brasilia - DF',
                      cep: '77.777-777',
                    ),
                    SizedBox(
                      height: wXD(15, context),
                    )
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
