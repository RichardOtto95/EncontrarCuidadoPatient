import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/appointment_model.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/schedule/schedule_store.dart';
import 'package:encontrarCuidado/app/modules/specialty/widgets/confirm_appointment.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/appointment_value.dart';
import 'package:encontrarCuidado/app/shared/widgets/doctor_note.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrarCuidado/app/shared/widgets/info_text.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Reschedule extends StatefulWidget {
  @override
  _RescheduleState createState() => _RescheduleState();
}

class _RescheduleState extends State<Reschedule> {
  final MainStore mainStore = Modular.get();
  final ScheduleStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();

  FocusNode infoFocus;
  FocusNode dddFocus;
  FocusNode numberFocus;

  bool check = false;
  bool guarantee = false;
  bool showDependents = false;
  bool dependents = false;

  @override
  void initState() {
    infoFocus = FocusNode();
    dddFocus = FocusNode();
    numberFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    infoFocus.dispose();
    dddFocus.dispose();
    numberFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = mainStore.appointmentReschedule.dependentId == null ? 0 : 1;
    return Default(
      topWidget: Container(),
      title: 'Confirmar Reagendamento',
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
              // String speciality = doc['speciality_name'];
              // String profission;
              // switch (speciality) {
              //   case 'Psiquiatria':
              //     profission = 'com Psiquiatra';
              //     break;
              //   case 'Geriatría':
              //     profission = 'com Geriatra';
              //     break;
              //   case 'Pediatra':
              //     profission = 'com Pediatra';
              //     break;
              //   case 'Clínica Geral':
              //     profission = 'geral';
              //     break;
              //   default:
              //     profission = 'com ' +
              //         speciality.substring(
              //             0, doc['speciality_name'].length - 1) +
              //         'sta';
              //     break;
              // }
              store.countyNum =
                  FirebaseAuth.instance.currentUser.phoneNumber.substring(0, 3);
              store.phone =
                  getPhoneMask(FirebaseAuth.instance.currentUser.phoneNumber);
              double price = doc['price'].toDouble();
              store.price = price;
              // print(profission);
              return Observer(
                builder: (context) {
                  return Listener(
                    onPointerDown: (event) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (showDependents == true) {
                        setState(() {
                          showDependents = false;
                        });
                      }
                    },
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          index == 1
                              ? Container(
                                  padding: EdgeInsets.only(
                                    top: wXD(15, context),
                                    left: wXD(18, context),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        size: 17,
                                        color: Color(0xff2185D0),
                                      ),
                                      SizedBox(
                                        width: wXD(3, context),
                                      ),
                                      Text(
                                        'Dependente',
                                        style: TextStyle(
                                          color: Color(0xff2185D0),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.only(
                                    top: wXD(15, context),
                                    left: wXD(18, context),
                                    bottom: 0,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.person,
                                          size: 17, color: Color(0xff2185D0)),
                                      SizedBox(
                                        width: wXD(3, context),
                                      ),
                                      Text(
                                        'Para mim',
                                        style: TextStyle(
                                          color: Color(0xff2185D0),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ScheduleTitle(title: 'Tipo de visita*'),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 18),
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
                                    : 'Reagendamento',
                                hintStyle: TextStyle(
                                  fontSize: wXD(16, context),
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff707070),
                                ),
                              ),
                            ),
                          ),
                          ScheduleTitle(title: 'Informações pessoais*'),
                          InkWell(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              // print('on taaaaaaaaaaap');
                              store.setOnEditing(true);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 18),
                              width: wXD(375, context),
                              child: TextFormField(
                                // controller: textController,
                                enabled: false,
                                focusNode: infoFocus,
                                onEditingComplete: () {
                                  dddFocus.requestFocus();
                                },
                                onTap: () {
                                  store.setOnEditing(true);
                                },
                                cursorColor: Color(0xff707070),
                                validator: (val) {
                                  if (val == '') {
                                    return 'Este campo não pode ser vazio';
                                  } else {
                                    return null;
                                  }
                                },
                                initialValue:
                                    mainStore.appointmentReschedule.patientName,
                                onChanged: (val) => store.patientName = val,
                                decoration: InputDecoration.collapsed(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff707070),
                                    ),
                                  ),
                                  hintText: mainStore.appointmentReschedule
                                              .dependentId !=
                                          null
                                      ? 'Seu nome'
                                      : 'Nome completo do dependente',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff707070),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ScheduleTitle(title: 'Informações de contato*'),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: wXD(27, context)),
                                width: wXD(53, context),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [maskFormatterCountry],
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
                                      .instance.currentUser.phoneNumber
                                      .substring(0, 3),
                                  validator: (val) {
                                    if (val == '') {
                                      return 'Este campo não pode ser vazio';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) => store.countyNum,
                                  decoration: InputDecoration.collapsed(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                    hintText: FirebaseAuth
                                        .instance.currentUser.phoneNumber
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
                                margin:
                                    EdgeInsets.only(right: wXD(18, context)),
                                width: wXD(223, context),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [maskFormatterPhone],
                                  focusNode: numberFocus,
                                  onTap: () {
                                    store.setOnEditing(true);
                                  },
                                  onChanged: (val) => store.phone,
                                  initialValue: getPhoneMask(FirebaseAuth
                                      .instance.currentUser.phoneNumber),
                                  cursorColor: Color(0xff707070),
                                  decoration: InputDecoration.collapsed(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                    hintText: FirebaseAuth
                                        .instance.currentUser.phoneNumber
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
                            onYes: () => store.setCovidSymptoms(true),
                            onNo: () => store.setCovidSymptoms(false),
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
                            onYes: () => store.setFirstAppointment(true),
                            onNo: () => store.setFirstAppointment(false),
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
                            onTap: () => setState(() => guarantee = !guarantee),
                          ),
                          AppointmentValue(
                              price: mainStore.returning
                                  ? 0
                                  : doc['price'].toDouble()),
                          store.appointmentCircular
                              ? Center(child: CircularProgressIndicator())
                              : RequestButton(onTap: () {
                                  if (!check) {
                                    Fluttertoast.showToast(
                                        msg: 'Aceite os termos para prosseguir',
                                        backgroundColor: Colors.red[400]);
                                  } else if (!_formKey.currentState
                                      .validate()) {
                                    Fluttertoast.showToast(
                                        msg: 'Preencha os campos corretamente',
                                        backgroundColor: Colors.red[400]);
                                  } else if (!guarantee) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Confirme estar ciente do caução para prosseguir.");
                                  } else {
                                    store.confirmAppointment(index, context,
                                        store.scheduleSelected.doctorId);
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
                  );
                },
              );
            }
          },
        )
      ],
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
            'Solicitar reagendamento',
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
              Spacer(
                flex: 3,
              ),
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
                          fontSize: wXD(15, context),
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
                  width: wXD(120, context),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: wXD(18, context),
                        color:
                            index == 1 ? Color(0xff2185D0) : Color(0xff707070),
                      ),
                      SizedBox(
                        width: wXD(3, context),
                      ),
                      Text(
                        'Dependentes',
                        style: TextStyle(
                          color: index == 1
                              ? Color(0xff2185D0)
                              : Color(0xff707070),
                          fontWeight: FontWeight.w700,
                          fontSize: wXD(15, context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(
                flex: 3,
              ),
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

  const Default({
    Key key,
    this.children,
    this.title,
    this.topWidget,
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
                Navigator.pop(context);
              },
              title: title,
            ),
            topWidget,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
