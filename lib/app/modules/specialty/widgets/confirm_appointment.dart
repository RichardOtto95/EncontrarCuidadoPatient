import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/schedule/schedule_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/appointment_value.dart';
import 'package:encontrarCuidado/app/shared/widgets/dependent_tile.dart';
import 'package:encontrarCuidado/app/shared/widgets/doctor_note.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrarCuidado/app/shared/widgets/info_text.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfirmAppointment extends StatefulWidget {
  final boolRouterConsulationDetail;

  const ConfirmAppointment({
    Key key,
    this.boolRouterConsulationDetail = false,
  }) : super(key: key);
  @override
  _ConfirmAppointmentState createState() => _ConfirmAppointmentState();
}

class _ConfirmAppointmentState extends State<ConfirmAppointment> {
  final ScheduleStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final _formKey = GlobalKey<FormState>();
  OverlayEntry confirmOverlay;

  ScrollController scrollController = ScrollController();

  int index = 0;
  bool check = false;
  bool guarantee = false;
  bool showDependents = false;
  bool canEditWho = true;
  String dependentName = '';
  FocusNode infoFocus;
  FocusNode dddFocus;
  FocusNode numberFocus;

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        store.setOnEditing(false);
      }
    });
  }

  @override
  void initState() {
    infoFocus = FocusNode();
    dddFocus = FocusNode();
    numberFocus = FocusNode();
    handleScroll();
    super.initState();
  }

  @override
  void dispose() {
    infoFocus.dispose();
    dddFocus.dispose();
    numberFocus.dispose();
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mainStore.returning) {
      canEditWho = false;
      if (mainStore.appointmentReturn.dependentId != null) {
        index = 1;
        store.patientName = mainStore.appointmentReturn.patientName;
        dependentName = mainStore.appointmentReturn.patientName;
        // print(store.patientName);
        store.dependentId = mainStore.appointmentReturn.dependentId;
        // print(store.dependentId);
      }
    }
    return WillPopScope(
      onWillPop: () {
        Modular.to.pop();
        store.onEditing = false;
        return Future(() => true);
      },
      child: Default(
        onBack: () => store.onEditing = false,
        scrollController: scrollController,
        title: 'Confirmar Agendamento',
        topWidget: Observer(builder: (context) {
          return AnimatedContainer(
            curve: Curves.ease,
            duration: Duration(milliseconds: 300),
            height: !store.onEditing ? wXD(105, context) : 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TitleWidget(
                      title: 'Para quem é a consulta?',
                      top: wXD(21, context),
                      left: wXD(18, context),
                      bottom: wXD(0, context),
                    ),
                  ),
                  TracinhoQueMarca(
                    index: index,
                    onTap0: () {
                      if (index != 0 && canEditWho) {
                        setState(() {
                          store.dependentId = '';
                          index = 0;
                        });
                      }
                    },
                    onTap1: () {
                      if (index != 1 && canEditWho) {
                        setState(() {
                          index = 1;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('doctors')
                .doc(store.scheduleSelected.doctorId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.only(top: wXD(40, context)),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              } else {
                DocumentSnapshot doc = snapshot.data;

                store.countyNum = FirebaseAuth.instance.currentUser.phoneNumber
                    .substring(0, 3);
                store.phone =
                    getPhoneMask(FirebaseAuth.instance.currentUser.phoneNumber);
                double price = doc['price'].toDouble();
                store.price = price;
                // print(profission);
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('patients')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        padding: EdgeInsets.only(top: wXD(40, context)),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      DocumentSnapshot patientDoc = snapshot.data;
                      store.setPatientName(index == 0
                          ? patientDoc['fullname'] ?? patientDoc['username']
                          : dependentName);
                      return Observer(
                        builder: (context) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Listener(
                                onPointerDown: (event) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  if (showDependents == true) {
                                    setState(() {
                                      showDependents = false;
                                    });
                                  }
                                },
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ScheduleTitle(title: 'Tipo de visita'),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 18),
                                        width: wXD(375, context),
                                        child: TextFormField(
                                          enabled: false,
                                          onEditingComplete: () {
                                            infoFocus.requestFocus();
                                          },
                                          onTap: () {
                                            store.setOnEditing(true);
                                          },
                                          cursorColor: Color(0xff707070),
                                          decoration: InputDecoration.collapsed(
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff707070),
                                              ),
                                            ),
                                            hintText: mainStore.returning
                                                ? 'Retorno médico'
                                                : 'Consulta médica',
                                            hintStyle: TextStyle(
                                              fontSize: wXD(16, context),
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff707070),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ScheduleTitle(
                                          title: 'Informações pessoais*'),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          print('on taaaaaaaaaaap');
                                          if (index == 1 && canEditWho) {
                                            store.setOnEditing(true);
                                            setState(() {
                                              if (showDependents == false) {
                                                showDependents = true;
                                              } else {
                                                showDependents = false;
                                              }
                                            });
                                          }
                                        },
                                        child: Observer(builder: (context) {
                                          return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 18),
                                              width: wXD(375, context),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Color(
                                                                  0xff707070)
                                                              .withOpacity(.5),
                                                          width: 0.5))),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                index == 0
                                                    ? patientDoc['fullname'] ??
                                                        patientDoc['username']
                                                    : store.dependentId == ''
                                                        ? 'Selecione um dependente'
                                                        : store.patientName,
                                                style: TextStyle(
                                                  fontSize: wXD(16, context),
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff707070),
                                                ),
                                              ));
                                        }),
                                      ),
                                      ScheduleTitle(
                                          title: 'Informações de contato*'),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: wXD(27, context)),
                                            width: wXD(53, context),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                maskFormatterCountry
                                              ],
                                              focusNode: dddFocus,
                                              onEditingComplete: () {
                                                numberFocus.requestFocus();
                                              },
                                              onTap: () {
                                                store.setOnEditing(true);
                                              },
                                              textAlign: TextAlign.center,
                                              cursorColor: Color(0xff707070),
                                              initialValue: FirebaseAuth
                                                  .instance
                                                  .currentUser
                                                  .phoneNumber
                                                  .substring(0, 3),
                                              validator: (val) {
                                                if (val == '') {
                                                  return 'Este campo não pode ser vazio';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onChanged: (val) =>
                                                  store.countyNum,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xff707070),
                                                  ),
                                                ),
                                                hintText: FirebaseAuth.instance
                                                    .currentUser.phoneNumber
                                                    .substring(0, 3),
                                                hintStyle: TextStyle(
                                                  fontSize: wXD(16, context),
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff707070),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: wXD(18, context)),
                                            width: wXD(223, context),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                maskFormatterPhone
                                              ],
                                              focusNode: numberFocus,
                                              onTap: () {
                                                store.setOnEditing(true);
                                              },
                                              onChanged: (val) => store.phone,
                                              initialValue: getPhoneMask(
                                                  FirebaseAuth.instance
                                                      .currentUser.phoneNumber),
                                              cursorColor: Color(0xff707070),
                                              decoration:
                                                  InputDecoration.collapsed(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xff707070),
                                                  ),
                                                ),
                                                hintText: FirebaseAuth.instance
                                                    .currentUser.phoneNumber
                                                    .substring(3, 14),
                                                hintStyle: TextStyle(
                                                  fontSize: wXD(16, context),
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff707070),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      InfoText(
                                        // top: 13,
                                        weight: FontWeight.w600,
                                        height: 1.4,
                                        left: 20,
                                        size: 13,
                                        title:
                                            '''Você receberá um código nesse número para confirmar o agendamento, e também receberá um lembrete antes da consulta.''',
                                      ),
                                      InfoText(
                                        top: 13,
                                        weight: FontWeight.w600,
                                        color: Color(0xff4c4c4c),
                                        left: 20,
                                        height: 1.3,
                                        size: 17,
                                        title:
                                            '''Teve sintomas de febres, tosse ou dificuldades de respirar ou teve contato com alguém com esses sintomas? *''',
                                      ),
                                      YesNo(
                                        yesNo: store.covidSymptoms,
                                        onYes: () =>
                                            store.setCovidSymptoms(true),
                                        onNo: () =>
                                            store.setCovidSymptoms(false),
                                      ),
                                      InfoText(
                                        top: 0,
                                        weight: FontWeight.w600,
                                        color: Color(0xff4c4c4c),
                                        left: 20,
                                        height: 1.3,
                                        size: 17,
                                        title:
                                            '''É a primeira consulta com este especialista? *''',
                                      ),
                                      YesNo(
                                        yesNo: store.firstAppointment,
                                        onYes: () =>
                                            store.setFirstAppointment(true),
                                        onNo: () =>
                                            store.setFirstAppointment(false),
                                      ),
                                      InfoText(
                                        top: 0,
                                        weight: FontWeight.w600,
                                        color: Color(0xff4c4c4c),
                                        left: 20,
                                        height: 1.3,
                                        size: 17,
                                        title:
                                            '''Informações adicionais para o doutor (opcional)''',
                                      ),
                                      DoctorNote(
                                        onTap: () {
                                          store.setOnEditing(true);
                                        },
                                        onChanged: (val) => store.setNote(val),
                                        text:
                                            'Indique qualquer informação que você gostaria de compartilhar com o doutor antes da consulta.',
                                      ),
                                      InfoText(
                                        top: 0,
                                        weight: FontWeight.w600,
                                        color: Color(0xff4c4c4c),
                                        left: 20,
                                        height: 1.3,
                                        size: 13,
                                        title:
                                            'Será cobrado 30% do valor da consulta antecipadamente como caução. Caso deseje desmarcar, faça-o em até 48h para receber o estorno integral automaticamente. Desmarcações com menos de 48h devem ser solicitadas ao próprio especialista ficando a critério dele o estorno.',
                                      ),
                                      ConditionsPrivacity(
                                        check: check,
                                        onTap: () {
                                          setState(() {
                                            check = !check;
                                          });
                                        },
                                      ),
                                      ConditionsGuarantee(
                                        check: guarantee,
                                        onTap: () {
                                          setState(() {
                                            guarantee = !guarantee;
                                          });
                                        },
                                      ),
                                      AppointmentValue(
                                          schedulingReturn: mainStore.returning,
                                          price: doc['price'].toDouble()),
                                      store.appointmentCircular
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : RequestButton(onTap: () {
                                              if (index == 0) {
                                                store.patientName =
                                                    patientDoc['username'] ??
                                                        patientDoc['username'];
                                              }

                                              if (store.dependentId == '' &&
                                                  index == 1) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Selecione um dependente para prosseguir.',
                                                    backgroundColor:
                                                        Colors.red[400]);
                                              } else if (!check) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Aceite os termos para prosseguir.',
                                                    backgroundColor:
                                                        Colors.red[400]);
                                              } else if (!guarantee) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Confirme estar ciente do caução para prosseguir.");
                                              } else if (!_formKey.currentState
                                                  .validate()) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Preencha os campos corretamente.',
                                                    backgroundColor:
                                                        Colors.red[400]);
                                              } else {
                                                print(
                                                    'xxxxxxxxxxxxx onTapp $index xxxxxxxxxx');
                                                store.confirmAppointment(
                                                    index,
                                                    context,
                                                    store.scheduleSelected
                                                        .doctorId);
                                              }
                                            }),
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: wXD(24, context),
                                            bottom: wXD(47, context),
                                          ),
                                          child: Text(
                                            '* Campo obrigatório',
                                            style: TextStyle(
                                              color: Color(0xff4c4c4c),
                                              fontSize: wXD(16, context),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: wXD(122, context),
                                child: Visibility(
                                  visible: showDependents,
                                  child: Container(
                                    // height: wXD(50, context),
                                    width: wXD(334, context),
                                    padding: EdgeInsets.only(
                                      top: wXD(5, context),
                                      bottom: wXD(10, context),
                                      left: wXD(12, context),
                                      right: wXD(12, context),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: wXD(20, context)),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      color: Color(0xfffafafa),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0x30000000),
                                            blurRadius: 5,
                                            offset: Offset(0, 3))
                                      ],
                                    ),
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('patients')
                                          .doc(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .collection('dependents')
                                          .where('status', isEqualTo: 'ACTIVE')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container(
                                              alignment: Alignment.center,
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          // print(snapshot.data.docs.first.data());
                                          QuerySnapshot _qs = snapshot.data;
                                          if (_qs.docs.length == 0) {
                                            return Container(
                                              height: wXD(50, context),
                                              alignment: Alignment.center,
                                              child: Text(
                                                  'Sem dependentes cadastrados'),
                                            );
                                          }
                                          return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: List.generate(
                                                  _qs.docs.length, (index) {
                                                DocumentSnapshot _ds =
                                                    _qs.docs[index];
                                                return DependentTile(
                                                  onTap: () {
                                                    print(
                                                        '_dsFullname ${_ds['fullname']}');
                                                    dependentName =
                                                        _ds['fullname'];
                                                    store.setPatientName(
                                                        _ds['fullname']);

                                                    print(
                                                        'store store.patientName');
                                                    store.dependentId = _ds.id;
                                                    setState(() {
                                                      showDependents = false;
                                                    });
                                                  },
                                                  name: _ds['fullname'],
                                                );
                                              }));
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class ConditionsGuarantee extends StatelessWidget {
  final bool check;
  final Function onTap;

  const ConditionsGuarantee({Key key, this.check, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: wXD(18, context),
        top: wXD(17, context),
        right: wXD(28, context),
        bottom: wXD(15, context),
      ),
      child: Row(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(right: wXD(15, context)),
              height: wXD(22, context),
              width: wXD(22, context),
              decoration: BoxDecoration(
                color: check ? Color(0xff2676E1) : Color(0xfffafafa),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Color(0xff707070).withOpacity(.3)),
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
          ),
          Container(
            width: wXD(291, context),
            child: Text(
              "* Estou ciente do caução de 30% que será cobrado ao confirmar a consulta.",
              style: TextStyle(
                  fontSize: 13,
                  color: Color(0xff4c4c4c),
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class ConditionsPrivacity extends StatelessWidget {
  final bool check;
  final Function onTap;

  const ConditionsPrivacity({Key key, this.check, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: wXD(18, context),
        top: wXD(17, context),
        right: wXD(28, context),
        bottom: wXD(12, context),
      ),
      child: Row(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(right: wXD(15, context)),
              height: wXD(22, context),
              width: wXD(22, context),
              decoration: BoxDecoration(
                color: check ? Color(0xff2676E1) : Color(0xfffafafa),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Color(0xff707070).withOpacity(.3)),
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
          ),
          Container(
            width: wXD(291, context),
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
                  TextSpan(text: 'da EncontrarCuidado.'),
                ])),
          ),
        ],
      ),
    );
  }
}

class RequestButton extends StatelessWidget {
  final Function onTap;

  const RequestButton({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: wXD(240, context),
          height: wXD(47, context),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 3, offset: Offset(0, 3), color: Color(0x30000000))
            ],
            borderRadius: BorderRadius.all(Radius.circular(18)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff41C3B3),
                  Color(0xff21BCCE),
                ]),
          ),
          alignment: Alignment.center,
          child: Text(
            'Solicitar agendamento',
            style: TextStyle(
              color: Color(0xfffafafa),
              fontSize: wXD(18, context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class CheckConditions extends StatelessWidget {
  final bool check;
  final Function onTap;

  const CheckConditions({Key key, this.check, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: wXD(20, context),
        width: wXD(20, context),
        decoration: BoxDecoration(
          color: check ? Color(0xff2676E1) : Color(0xfffafafa),
          borderRadius: BorderRadius.all(Radius.circular(90)),
          border: Border.all(color: Color(0xff707070).withOpacity(.3)),
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
  }
}

class YesNo extends StatelessWidget {
  final bool yesNo;
  final Function onYes;
  final Function onNo;

  const YesNo({
    Key key,
    this.yesNo = false,
    this.onYes,
    this.onNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: wXD(17, context),
        horizontal: wXD(30, context),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onYes,
            child: Container(
              height: wXD(20, context),
              width: wXD(20, context),
              decoration: BoxDecoration(
                color: yesNo ? Color(0xff2676E1) : Color(0xfffafafa),
                borderRadius: BorderRadius.all(Radius.circular(90)),
                border: Border.all(color: Color(0xff707070).withOpacity(.3)),
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
          ),
          Padding(
            padding: EdgeInsets.only(
              left: wXD(8, context),
              right: wXD(17, context),
            ),
            child: Text(
              'Sim',
              style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w400,
                fontSize: wXD(18, context),
              ),
            ),
          ),
          InkWell(
            onTap: onNo,
            child: Container(
              height: wXD(20, context),
              width: wXD(20, context),
              decoration: BoxDecoration(
                color: yesNo ? Color(0xfffafafa) : Color(0xff2676E1),
                borderRadius: BorderRadius.all(Radius.circular(90)),
                border: Border.all(color: Color(0xff707070).withOpacity(.3)),
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
          ),
          Padding(
            padding: EdgeInsets.only(
              left: wXD(8, context),
              right: wXD(17, context),
            ),
            child: Text(
              'Não',
              style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w400,
                fontSize: wXD(18, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleTitle extends StatelessWidget {
  final String title;

  const ScheduleTitle({
    Key key,
    this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TitleWidget(
      style: TextStyle(
        color: Color(0xff4C4C4C),
        fontSize: wXD(17, context),
        fontWeight: FontWeight.w600,
      ),
      title: title,
      top: wXD(15, context),
      left: wXD(18, context),
      bottom: wXD(15, context),
    );
  }
}

class TracinhoQueMarca extends StatelessWidget {
  final int index;
  final Function onTap0;
  final Function onTap1;

  const TracinhoQueMarca({
    Key key,
    this.index = 0,
    this.onTap0,
    this.onTap1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: wXD(60, context),
          width: wXD(375, context),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 2,
                color: Color(0x30000000),
              )
            ],
            color: Color(0xfffafafa),
          ),
          child: Row(
            children: [
              Spacer(flex: 3),
              InkWell(
                onTap: onTap0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: wXD(20, context)),
                  width: wXD(120, context),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: wXD(18, context),
                        color:
                            index == 0 ? Color(0xff2185D0) : Color(0xff707070),
                      ),
                      SizedBox(
                        width: wXD(3, context),
                      ),
                      Text(
                        'Para mim',
                        style: TextStyle(
                          color: index == 0
                              ? Color(0xff2185D0)
                              : Color(0xff707070),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(
                flex: 5,
              ),
              InkWell(
                onTap: onTap1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: wXD(20, context)),
                  width: wXD(122, context),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: wXD(18, context),
                        color:
                            index == 1 ? Color(0xff2185D0) : Color(0xff707070),
                      ),
                      SizedBox(width: wXD(3, context)),
                      Text(
                        'Dependentes',
                        style: TextStyle(
                          color: index == 1
                              ? Color(0xff2185D0)
                              : Color(0xff707070),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(flex: 3),
            ],
          ),
        ),
        AnimatedPositioned(
          bottom: 0,
          left: index == 0
              ? wXD(53, context)
              : index == 1
                  ? wXD(218, context)
                  : 0,
          curve: Curves.ease,
          duration: Duration(milliseconds: 300),
          child: AnimatedContainer(
            curve: Curves.ease,
            duration: Duration(milliseconds: 300),
            height: wXD(2, context),
            width: index == 0
                ? wXD(94, context)
                : index == 1
                    ? wXD(117, context)
                    : 0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              color: Color(0xff2185d0),
            ),
          ),
        )
      ],
    );
  }
}

class Default extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final Widget topWidget;
  final Function onBack;
  final ScrollController scrollController;

  const Default({
    Key key,
    this.children,
    this.title,
    this.topWidget,
    this.scrollController,
    this.onBack,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      body: SafeArea(
        child: Column(
          children: [
            EncontrarCuidadoAppBar(
              onTap: () {
                Modular.to.pop();
                onBack();
              },
              title: title,
            ),
            topWidget,
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
