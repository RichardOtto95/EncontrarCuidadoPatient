import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:encontrarCuidado/app/modules/dependents/dependents_store.dart';
import 'package:encontrarCuidado/app/modules/dependents/widgets/confirm_dependent.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'data_tile_dependent.dart';
import 'title_widget_dependent.dart';

class AddDependent extends StatefulWidget {
  @override
  _AddDependentState createState() => _AddDependentState();
}

class _AddDependentState extends State<AddDependent> {
  final DependentsStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();
  List<String> listGender = ['Masculino', 'Feminino', 'Outro'];
  ScrollController _scrollController = ScrollController();

  FocusNode fullNameFocus;
  FocusNode birthdayFocus;
  FocusNode cpfFocus;
  FocusNode emailFocus;
  FocusNode phoneFocus;
  FocusNode cepFocus;
  FocusNode addressFocus;
  FocusNode numberAddressFocus;
  FocusNode complementAddressFocus;
  FocusNode neighborhoodFocus;
  FocusNode cityFocus;
  FocusNode stateFocus;

  @override
  void initState() {
    super.initState();
    fullNameFocus = FocusNode();
    birthdayFocus = FocusNode();
    cpfFocus = FocusNode();
    emailFocus = FocusNode();
    phoneFocus = FocusNode();
    cepFocus = FocusNode();
    addressFocus = FocusNode();
    numberAddressFocus = FocusNode();
    complementAddressFocus = FocusNode();
    neighborhoodFocus = FocusNode();
    cityFocus = FocusNode();
    stateFocus = FocusNode();
  }

  @override
  void dispose() {
    fullNameFocus.dispose();
    birthdayFocus.dispose();
    cpfFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    cepFocus.dispose();
    addressFocus.dispose();
    numberAddressFocus.dispose();
    complementAddressFocus.dispose();
    neighborhoodFocus.dispose();
    cityFocus.dispose();
    stateFocus.dispose();
    store.back();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        store.back();

        return true;
      },
      child: Scaffold(
        body: Listener(
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
                                  store.back();

                                  Modular.to.pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  size: maxWidth * 26 / 375,
                                  color: Color(0xff707070),
                                ),
                              ),
                            ),
                            Text(
                              'Adicionar dependente',
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
                              DataTileDependent(
                                title: 'Nome completo',
                                hint: 'Ex: Fulano De Tal',
                                type: 'fullname',
                                focusNode: fullNameFocus,
                                mandatory: true,
                              ),
                              DataTileDependent(
                                title: 'Data de nascimento*',
                                type: 'birthday',
                                iconTap: () {
                                  store.selectDate(context);
                                },
                              ),
                              DataTileDependent(
                                title: 'CPF',
                                type: 'cpf',
                                focusNode: cpfFocus,
                                hint: 'Ex: 999.999.999-99',
                                mandatory: store.needCpf,
                              ),
                              DataTileDependent(
                                title: 'Gênero*',
                                type: 'gender',
                                iconTap: () {
                                  store.genderDialog = true;
                                },
                              ),
                              TitleWidgetDependent(
                                title: 'Dados de contato',
                              ),
                              DataTileDependent(
                                hint: 'Ex: Fulano@gmail.com',
                                title: 'E-mail',
                                type: 'email',
                                focusNode: emailFocus,
                                mandatory: true,
                                onEditingComplete: () {
                                  phoneFocus.requestFocus();
                                },
                              ),
                              DataTileDependent(
                                hint: 'Ex: +55 (61) 99999-9999',
                                title: 'Telefone',
                                type: 'phone',
                                focusNode: phoneFocus,
                                mandatory: true,
                                onEditingComplete: () {
                                  cepFocus.requestFocus();
                                },
                              ),
                              TitleWidgetDependent(
                                title: 'Endereço',
                              ),
                              DataTileDependent(
                                hint: 'Ex: 99.999-999',
                                title: 'CEP',
                                type: 'cep',
                                focusNode: cepFocus,
                                mandatory: true,
                                onEditingComplete: () {
                                  addressFocus.requestFocus();
                                },
                              ),
                              DataTileDependent(
                                hint: 'Ex: Rua 123, conjunto 01, casa 05',
                                title: 'Endereço',
                                type: 'address',
                                focusNode: addressFocus,
                                mandatory: true,
                                onEditingComplete: () {
                                  numberAddressFocus.requestFocus();
                                },
                              ),
                              DataTileDependent(
                                hint: 'Ex: 04',
                                title: 'Número',
                                type: 'number_address',
                                focusNode: numberAddressFocus,
                                onEditingComplete: () {
                                  complementAddressFocus.requestFocus();
                                },
                              ),
                              DataTileDependent(
                                hint: 'Ex: Ao lado da padaria',
                                title: 'Complemento',
                                type: 'complement_address',
                                focusNode: complementAddressFocus,
                                onEditingComplete: () {
                                  neighborhoodFocus.requestFocus();
                                },
                              ),
                              DataTileDependent(
                                hint: 'Ex: Bairro simples',
                                title: 'Bairro',
                                type: 'neighborhood',
                                focusNode: neighborhoodFocus,
                                onEditingComplete: () {
                                  store.focusNodeState.requestFocus();
                                },
                              ),
                              DataTileDependent(
                                title: 'Estado*',
                                type: 'state',
                                iconTap: () {
                                  store.focusNodeState.requestFocus();
                                },
                              ),
                              DataTileDependent(
                                title: 'Cidade*',
                                type: 'city',
                                iconTap: () {
                                  store.focusNodeCity.requestFocus();
                                },
                              ),
                              Observer(
                                builder: (context) {
                                  return Center(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await store.getValidate();
                                        if (_formKey.currentState.validate() &&
                                            store.valid) {
                                          // store.loadCircular = true;
                                          OverlayEntry confirmOverlay;
                                          confirmOverlay = OverlayEntry(
                                              builder: (context) =>
                                                  ConfirmDependent(
                                                    onConfirm: () async {
                                                      OverlayEntry loadOverlay;
                                                      loadOverlay = OverlayEntry(
                                                          builder: (context) =>
                                                              LoadCircularOverlay());
                                                      Overlay.of(context)
                                                          .insert(loadOverlay);
                                                      await store
                                                          .confirmAddDependent();
                                                      loadOverlay.remove();
                                                      confirmOverlay.remove();
                                                    },
                                                    onBack: () {
                                                      confirmOverlay.remove();
                                                    },
                                                    svgWay:
                                                        "./assets/svg/confirmadddependent.svg",
                                                    text:
                                                        "Tem certeza que deseja adicionar\nesse dependente?",
                                                  ));
                                          Overlay.of(context)
                                              .insert(confirmOverlay);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Preencha os campos obrigatórios corretamente",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red[700],
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          _scrollController.jumpTo(0.00);
                                        }
                                      },
                                      child: Container(
                                        width: maxWidth * .66,
                                        height: maxWidth * .13,
                                        margin: EdgeInsets.only(
                                          top: maxWidth * .07,
                                          bottom: maxWidth * .085,
                                        ),
                                        alignment: Alignment.center,
                                        child: store.loadCircular
                                            ? CircularProgressIndicator()
                                            : Text(
                                                'Salvar Dependente',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 3),
                                              color: Color(0x25000000),
                                              blurRadius: 4,
                                            )
                                          ],
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
                                },
                              ),
                              Observer(
                                builder: (context) {
                                  if (store.input) {
                                    Timer(Duration(milliseconds: 400), () {
                                      _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeIn);
                                    });
                                  }
                                  return AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    height: store.input ? wXD(50, context) : 0,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Observer(
                    builder: (context) {
                      return Visibility(
                        visible: store.genderDialog,
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
                                          store.genderDialog = false;
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
                                          store.mapDependentAdd['gender'] =
                                              listGender[store.listGenderIndex];
                                          store.genderDialog = false;
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
                                    initialPage: store.listGenderIndex,
                                    height: wXD(90, context),
                                    viewportFraction: .4,
                                    scrollDirection: Axis.vertical,
                                    onPageChanged: (index, reason) {
                                      store.listGenderIndex = index;
                                    },
                                  ),
                                  items: listGender.map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return GestureDetector(
                                          onTap: () {
                                            store.mapDependentAdd['gender'] = i;
                                            for (var index = 0;
                                                index < listGender.length;
                                                index++) {
                                              String label = listGender[index];
                                              if (label == i) {
                                                store.listGenderIndex = index;
                                                break;
                                              }
                                            }
                                            store.genderDialog = false;
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: wXD(20, context)),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Color(0x70707070),
                                                  ),
                                                ),
                                              ),
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
