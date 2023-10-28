import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/specialty/specialty_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/empty_state.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/modules/specialty/widgets/specialist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Specialtie extends StatefulWidget {
  final specId;

  const Specialtie({Key key, this.specId}) : super(key: key);
  @override
  _SpecialtieState createState() => _SpecialtieState();
}

class _SpecialtieState extends ModularState<Specialtie, SpecialtyStore> {
  final SpecialtyStore store = Modular.get();

  final MainStore mainStore = Modular.get();

  @override
  void initState() {
    store.getDoctors(widget.specId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          store.showMenuFilter = false;
        },
        child: Stack(
          children: [
            Column(
              children: [
                EncontrarCuidadoNavBar(
                  leading: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: wXD(11, context), right: wXD(11, context)),
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            size: wXD(26, context),
                            color: Color(0xff707070),
                          ),
                        ),
                      ),
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('specialties')
                              .doc(widget.specId)
                              .get(),
                          builder: (context, snapshotName) {
                            if (!snapshotName.hasData) return Container();
                            DocumentSnapshot docSpec = snapshotName.data;

                            return Text(
                              docSpec['speciality'],
                              style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: wXD(20, context),
                              ),
                            );
                          }),
                    ],
                  ),
                  action: Container(
                    width: maxWidth * .10,
                    child: Row(
                      children: [
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () async {
                            store.showMenuFilter = !store.showMenuFilter;
                          },
                          child: Icon(
                            Icons.filter_list_rounded,
                            size: maxWidth * 25 / 375,
                            color: Color(0xff707070),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Observer(builder: (context) {
                  if (store.listDoctors == null) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (store.listDoctors.length == 0) {
                    return Expanded(
                      child: Column(
                        children: [
                          Spacer(flex: 1),
                          EmptyStateList(
                            image: 'assets/img/pacient_communication.png',
                            title: 'Sem especialistas cadastrados',
                            description:
                                'Não há especialistas para serem exibidos',
                          ),
                          Spacer(flex: 2),
                        ],
                      ),
                    );
                  }

                  return Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: wXD(20, context),
                        ),
                        Column(
                            children: store.listDoctors.map((spec) {
                          return Specialist(
                            id: spec['id'],
                            avatar: spec['avatar'],
                            name: spec['username'],
                            speciality: spec['speciality_name'],
                            hospital: spec['clinic_name'] != null
                                ? spec['clinic_name']
                                : 'Não informado',
                            price: spec['price'],
                          );
                        }).toList()),
                      ],
                    ),
                  ));
                })
              ],
            ),
            Observer(builder: (context) {
              return Visibility(
                visible: store.setCards,
                child: AnimatedContainer(
                  height: maxHeight,
                  width: maxWidth,
                  color:
                      !store.setCards ? Colors.transparent : Color(0x50000000),
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
                            width: wXD(240, context),
                            margin: EdgeInsets.only(top: wXD(15, context)),
                            child: Text(
                              '''Para realizar seu primeiro agendamento, é necessário adicionar um cartão em Perfil > Pagamentos > Adicionar Cartão. Deseja navegar para esta seção?''',
                              style: TextStyle(
                                fontSize: wXD(15, context),
                                fontWeight: FontWeight.w600,
                                color: Color(0xfa707070),
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  store.setCardDialog(!store.setCards);
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
                                  store.setCardDialog(!store.setCards);
                                  Modular.to.pushNamed('/payment/add-card',
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
            }),
            Observer(builder: (context) {
              return Visibility(
                visible: store.showMenuFilter,
                child: Container(
                  height: maxHeight,
                  width: maxWidth,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(
                    right: wXD(49, context),
                    top: wXD(32, context),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: wXD(10, context),
                    ),
                    height: wXD(89, context),
                    width: wXD(160, context),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color(0xff707070).withOpacity(.1)),
                      color: Color(0xfffafafa),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x15000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (store.indexFilter == 1) {
                              store.indexFilter = 0;
                            } else {
                              store.indexFilter = 1;
                            }
                            store.showMenuFilter = false;
                            store.getDoctors(widget.specId);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: wXD(20, context)),
                            width: wXD(160, context),
                            height: wXD(22, context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: store.indexFilter == 1
                                    ? Color(0xff41C3B3).withOpacity(.25)
                                    : Colors.transparent),
                            child: Text(
                              'Mais relevante',
                              style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (store.indexFilter == 2) {
                              store.indexFilter = 0;
                            } else {
                              store.indexFilter = 2;
                            }
                            store.showMenuFilter = false;
                            store.getDoctors(widget.specId);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: wXD(20, context)),
                            width: wXD(160, context),
                            height: wXD(22, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: store.indexFilter == 2
                                  ? Color(0xff41C3B3).withOpacity(.25)
                                  : Colors.transparent,
                            ),
                            child: Text(
                              'Menor preço',
                              style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (store.indexFilter == 3) {
                              store.indexFilter = 0;
                            } else {
                              store.indexFilter = 3;
                            }
                            store.showMenuFilter = false;
                            store.getDoctors(widget.specId);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: wXD(20, context)),
                            width: wXD(160, context),
                            height: wXD(22, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: store.indexFilter == 3
                                  ? Color(0xff41C3B3).withOpacity(.25)
                                  : Colors.transparent,
                            ),
                            child: Text(
                              'Maior preço',
                              style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      )),
    );
  }
}
