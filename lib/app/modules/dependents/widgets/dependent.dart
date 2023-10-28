import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:encontrarCuidado/app/core/models/dependent_model.dart';
import 'package:encontrarCuidado/app/modules/dependents/dependents_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'confirm_dependent.dart';
import 'data_tile_edit.dart';
import 'title_widget_dependent.dart';

class Dependent extends StatefulWidget {
  final DependentModel dependent;

  const Dependent({Key key, this.dependent}) : super(key: key);
  @override
  _DependentState createState() => _DependentState();
}

class _DependentState extends State<Dependent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DependentsStore store = Modular.get();
  List<String> listGender = ['Masculino', 'Feminino', 'Outro'];
  ScrollController _scrollController = ScrollController();

  FocusNode fullNameFocus;
  FocusNode cpfFocus;
  FocusNode emailFocus;
  FocusNode phoneFocus;
  FocusNode cepFocus;
  FocusNode addressFocus;
  FocusNode numberAddressFocus;
  FocusNode complementAddressFocus;
  FocusNode neighborhoodFocus;

  @override
  void initState() {
    super.initState();
    fullNameFocus = FocusNode();
    cpfFocus = FocusNode();
    emailFocus = FocusNode();
    phoneFocus = FocusNode();
    cepFocus = FocusNode();
    addressFocus = FocusNode();
    numberAddressFocus = FocusNode();
    complementAddressFocus = FocusNode();
    neighborhoodFocus = FocusNode();
    store.mapDependentUpdate['city'] = widget.dependent.city;
    store.mapDependentUpdate['state'] = widget.dependent.state;
    store.mapDependentUpdate['birthday'] = widget.dependent.birthday;
    store.mapDependentUpdate['gender'] = widget.dependent.gender;
    int years = DateTime.now().year - widget.dependent.birthday.toDate().year;
    print("##### YEARS: $years");
    store.needCpf = years >= 18;
  }

  @override
  void dispose() {
    fullNameFocus.dispose();
    cpfFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    cepFocus.dispose();
    addressFocus.dispose();
    numberAddressFocus.dispose();
    complementAddressFocus.dispose();
    neighborhoodFocus.dispose();
    store.clearErrorsEdit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    bool loadCircular = false;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          store.mapDependentUpdate.clear();
          return true;
        },
        child: Listener(
          onPointerDown: (event) {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EncontrarCuidadoNavBar(
                        leading: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: wXD(11, context),
                                  right: wXD(11, context)),
                              child: InkWell(
                                onTap: () {
                                  store.mapDependentUpdate.clear();

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
                              'Editar dependente',
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
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleWidgetDependent(
                                title: 'Dados pessoais',
                              ),
                              DataTileEdit(
                                type: 'fullname',
                                hint: 'Ex: Fulano de tal',
                                initialValue: widget.dependent.fullname,
                                title: 'Nome completo',
                                focusNode: fullNameFocus,
                                mandatory: true,
                              ),
                              DataTileEdit(
                                type: 'birthday',
                                hint: store.converterDate(null, true),
                                initialValue: store
                                    .converterDate(widget.dependent.birthday),
                                title: 'Data de nascimento ',
                                mandatory: true,
                                iconTap: () {
                                  store.selectDateEdit(context);
                                },
                              ),
                              DataTileEdit(
                                type: 'cpf',
                                hint: 'Ex: 999.999.999-99',
                                initialValue: widget.dependent.cpf,
                                title: 'CPF',
                                focusNode: cpfFocus,
                                mandatory: store.needCpf,
                              ),
                              DataTileEdit(
                                type: 'gender',
                                hint: 'Ex: Feminino',
                                initialValue: widget.dependent.gender,
                                title: 'Gênero',
                                mandatory: true,
                                iconTap: () {
                                  store.genderDialogEdit = true;
                                },
                              ),
                              TitleWidgetDependent(
                                title: 'Dados de contato',
                              ),
                              DataTileEdit(
                                type: 'email',
                                hint: 'Ex: fulano@gmail.com',
                                initialValue: widget.dependent.email,
                                title: 'E-mail',
                                focusNode: emailFocus,
                                mandatory: true,
                                onEditingComplete: () {
                                  phoneFocus.requestFocus();
                                },
                              ),
                              DataTileEdit(
                                type: 'phone',
                                hint: '+55 (61) 99999-9999',
                                initialValue: widget.dependent.phone,
                                title: 'Telefone',
                                focusNode: phoneFocus,
                                mandatory: true,
                                onEditingComplete: () {
                                  cepFocus.requestFocus();
                                },
                              ),
                              TitleWidgetDependent(
                                title: 'Endereço',
                              ),
                              DataTileEdit(
                                type: 'cep',
                                hint: 'Ex: 99.999-999',
                                initialValue: widget.dependent.cep,
                                title: 'CEP',
                                focusNode: cepFocus,
                                mandatory: true,
                                onEditingComplete: () {
                                  addressFocus.requestFocus();
                                },
                              ),
                              DataTileEdit(
                                type: 'address',
                                hint: 'Ex: Rua 123 conjunto 01',
                                initialValue: widget.dependent.address,
                                title: 'Endereço',
                                focusNode: addressFocus,
                                mandatory: true,
                                onEditingComplete: () {
                                  numberAddressFocus.requestFocus();
                                },
                              ),
                              DataTileEdit(
                                type: 'number_address',
                                hint: 'Ex: 04',
                                initialValue: widget.dependent.numberAddress,
                                title: 'Número',
                                focusNode: numberAddressFocus,
                                onEditingComplete: () {
                                  complementAddressFocus.requestFocus();
                                },
                              ),
                              DataTileEdit(
                                type: 'complement_address',
                                hint: 'Ex: Ao lado da quadra',
                                initialValue:
                                    widget.dependent.complementAddress,
                                title: 'Complemento',
                                focusNode: complementAddressFocus,
                                onEditingComplete: () {
                                  neighborhoodFocus.requestFocus();
                                },
                              ),
                              DataTileEdit(
                                type: 'neighborhood',
                                hint: 'Ex: Bairro simples',
                                initialValue: widget.dependent.neighborhood,
                                title: 'Bairro',
                                focusNode: neighborhoodFocus,
                              ),
                              DataTileEdit(
                                type: 'state',
                                hint: 'Ex: DF',
                                title: 'Estado',
                                iconTap: () {
                                  if (!store.focusNodeCityEdit.hasFocus) {
                                    store.focusNodeStateEdit.requestFocus();
                                  } else {
                                    store.focusNodeStateEdit.unfocus();
                                  }
                                },
                              ),
                              DataTileEdit(
                                type: 'city',
                                hint: 'Ex: Taguatinga',
                                title: 'Cidade',
                                iconTap: () {
                                  if (!store.focusNodeCityEdit.hasFocus) {
                                    store.focusNodeCityEdit.requestFocus();
                                  } else {
                                    store.focusNodeCityEdit.unfocus();
                                  }
                                },
                              ),
                              Observer(builder: (context) {
                                if (store.inputEdit) {
                                  Timer(Duration(milliseconds: 400), () {
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(seconds: 1),
                                        curve: Curves.easeIn);
                                  });
                                }
                                return AnimatedContainer(
                                  duration: Duration(seconds: 0),
                                  height: store.inputEdit ? wXD(0, context) : 0,
                                );
                              }),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: wXD(20, context),
                                  ),
                                  height: maxWidth * .1493,
                                  width: maxWidth * .1493,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                      color: Color(0xff41C3B3),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 3),
                                            blurRadius: 3,
                                            color: Color(0x30000000))
                                      ]),
                                  child: IconButton(
                                    onPressed: () async {
                                      await store.getValidateEdit();

                                      if (_formKey.currentState.validate() &&
                                          store.validEdit) {
                                        store.confirmDependentEdit(
                                            dependentId: widget.dependent.id);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Preencha os campos obrigatórios corretamente, inclusive a foto",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red[700],
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        _scrollController.jumpTo(0.00);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.check,
                                      color: Color(0xfffafafa),
                                      size: maxWidth * .1,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    // store.removeDependent = true;
                                    OverlayEntry confirmOverlay;
                                    confirmOverlay = OverlayEntry(
                                        builder: (context) => ConfirmDependent(
                                              onConfirm: () async {
                                                OverlayEntry loadOverlay;
                                                loadOverlay = OverlayEntry(
                                                    builder: (context) =>
                                                        LoadCircularOverlay());
                                                Overlay.of(context)
                                                    .insert(loadOverlay);
                                                await store
                                                    .confirmRemoveDependent(
                                                        dependentId: widget
                                                            .dependent.id);
                                                loadOverlay.remove();
                                                confirmOverlay.remove();
                                              },
                                              onBack: () {
                                                confirmOverlay.remove();
                                              },
                                              svgWay:
                                                  "./assets/svg/confirmremovedependent.svg",
                                              text:
                                                  "Tem certeza que deseja remover\nesse dependente?",
                                            ));
                                    Overlay.of(context).insert(confirmOverlay);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    margin: EdgeInsets.only(
                                        top: wXD(5, context),
                                        bottom: wXD(35, context)),
                                    decoration: BoxDecoration(
                                      color: Color(0xfffafafa),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(23)),
                                      border:
                                          Border.all(color: Color(0x50707070)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x25000000),
                                          offset: Offset(0, 4),
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                    height: wXD(48, context),
                                    width: maxWidth * .62,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Remover Dependente',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: wXD(18, context),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  StatefulBuilder(builder: (context, stateSet) {
                    return Observer(
                      builder: (context) {
                        return Visibility(
                          visible: store.removeDependent,
                          child: Container(
                            height: maxHeight,
                            width: maxWidth,
                            color: !store.removeDependent
                                ? Colors.transparent
                                : Color(0x50000000),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.only(top: wXD(5, context)),
                                height: wXD(160, context),
                                width: wXD(324, context),
                                decoration: BoxDecoration(
                                    color: Color(0xfffafafa),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(33))),
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Container(
                                      child: Text(
                                        '''Tem certeza que deseja remover
      esse dependente?''',
                                        style: TextStyle(
                                          fontSize: wXD(16, context),
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xfa707070),
                                        ),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 2,
                                    ),
                                    loadCircular
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
                                                  store.removeDependent = false;
                                                },
                                                child: Container(
                                                  height: wXD(47, context),
                                                  width: wXD(98, context),
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                Offset(0, 3),
                                                            blurRadius: 3,
                                                            color: Color(
                                                                0x28000000))
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  17)),
                                                      border: Border.all(
                                                          color: Color(
                                                              0x80707070)),
                                                      color: Color(0xfffafafa)),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Não',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff2185D0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            wXD(16, context)),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  stateSet(() {
                                                    loadCircular = true;
                                                  });
                                                  store.confirmRemoveDependent(
                                                      dependentId:
                                                          widget.dependent.id);
                                                },
                                                child: Container(
                                                  height: wXD(47, context),
                                                  width: wXD(98, context),
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                Offset(0, 3),
                                                            blurRadius: 3,
                                                            color: Color(
                                                                0x28000000))
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  17)),
                                                      border: Border.all(
                                                          color: Color(
                                                              0x80707070)),
                                                      color: Color(0xfffafafa)),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Sim',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff2185D0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            wXD(16, context)),
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
                      },
                    );
                  }),
                  Observer(
                    builder: (context) {
                      return Visibility(
                        visible: store.genderDialogEdit,
                        child: Container(
                          alignment: Alignment.center,
                          height: maxHeight,
                          width: maxWidth,
                          color: Color(0x50000000),
                          child: Container(
                            width: maxWidth,
                            height: wXD(201, context),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Color(0xfffafafa),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: wXD(19, context),
                                    vertical: wXD(10, context),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          store.genderDialogEdit = false;
                                        },
                                        child: Container(
                                          width: maxWidth * .3,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Cancelar',
                                            style: TextStyle(
                                                fontSize: wXD(15, context),
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        height: wXD(5, context),
                                        width: wXD(34, context),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: Color(0xff707070)
                                              .withOpacity(.35),
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          store.mapDependentUpdate['gender'] =
                                              listGender[
                                                  store.listGenderIndexEdit];
                                          store.genderDialogEdit = false;
                                        },
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          width: maxWidth * .3,
                                          child: InkWell(
                                            child: Text(
                                              'Selecionar',
                                              style: TextStyle(
                                                  fontSize: wXD(15, context),
                                                  color: Color(0xff2185D0),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                CarouselSlider(
                                  options: CarouselOptions(
                                    initialPage: store.listGenderIndexEdit,
                                    height: wXD(90, context),
                                    viewportFraction: .4,
                                    scrollDirection: Axis.vertical,
                                    onPageChanged: (index, reason) {
                                      store.listGenderIndexEdit = index;
                                    },
                                  ),
                                  items: listGender.map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return GestureDetector(
                                          onTap: () {
                                            store.mapDependentUpdate['gender'] =
                                                i;
                                            for (var index = 0;
                                                index < listGender.length;
                                                index++) {
                                              String label = listGender[index];
                                              if (label == i) {
                                                store.listGenderIndexEdit =
                                                    index;
                                                break;
                                              }
                                            }
                                            store.genderDialogEdit = false;
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: wXD(20, context)),
                                              decoration: BoxDecoration(),
                                              child: Text(
                                                i,
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              )),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
