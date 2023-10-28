import 'dart:async';
import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/person_photo.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../profile_store.dart';
import 'data_tile_profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';

class EditProfile extends StatefulWidget {
  final PatientModel patientModel;

  const EditProfile({Key key, this.patientModel}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  List<String> listGender = ['Masculino', 'Feminino', 'Outro'];

  FocusNode nameFocus;
  FocusNode fullNameFocus;
  FocusNode dateNacFocus;
  FocusNode cpfFocus;
  FocusNode genderFocus;
  FocusNode emailFocus;
  FocusNode emailFocus2;
  FocusNode phoneFocus;
  FocusNode cepFocus;
  FocusNode addressFocus;
  FocusNode addressNumFocus;
  FocusNode addressComplementFocus;
  FocusNode neighborhoodFocus;
  FocusNode cityFocus;
  FocusNode stateFocus;

  @override
  void initState() {
    store.setMapPatient(widget.patientModel);
    super.initState();
    nameFocus = FocusNode();
    fullNameFocus = FocusNode();
    dateNacFocus = FocusNode();
    cpfFocus = FocusNode();
    genderFocus = FocusNode();
    emailFocus = FocusNode();
    emailFocus2 = FocusNode();
    phoneFocus = FocusNode();
    cepFocus = FocusNode();
    addressFocus = FocusNode();
    addressNumFocus = FocusNode();
    addressComplementFocus = FocusNode();
    neighborhoodFocus = FocusNode();
    cityFocus = FocusNode();
    stateFocus = FocusNode();
  }

  @override
  void dispose() {
    nameFocus.dispose();
    fullNameFocus.dispose();
    dateNacFocus.dispose();
    cpfFocus.dispose();
    genderFocus.dispose();
    emailFocus.dispose();
    emailFocus2.dispose();
    phoneFocus.dispose();
    cepFocus.dispose();
    addressFocus.dispose();
    addressNumFocus.dispose();
    addressComplementFocus.dispose();
    neighborhoodFocus.dispose();
    cityFocus.dispose();
    stateFocus.dispose();
    store.genderDialog = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        if (store.confirmCodeOverlay != null &&
            store.confirmCodeOverlay.mounted) {
          return false;
        } else {
          store.newListCitys.clear();
          store.newListStates.clear();
          store.clearErrors();
          return true;
        }
      },
      child: Listener(
        onPointerDown: (event) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: maxWidth,
                    height: wXD(203, context),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5,
                            color: Color(0x40000000),
                            offset: Offset(0, 3))
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff41C3B3),
                          Color(0xff21BCCE),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(25)),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: wXD(20, context),
                            left: wXD(12, context),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (store.confirmCodeOverlay != null &&
                                      store.confirmCodeOverlay.mounted) {
                                  } else {
                                    store.newListCitys.clear();
                                    store.newListStates.clear();
                                    store.clearErrors();

                                    Modular.to.pop();
                                  }
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  size: maxWidth * 28 / 375,
                                  color: Color(0xfffafafa),
                                ),
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              Text(
                                'Editar Perfil',
                                style: TextStyle(
                                    color: Color(0xfffafafa),
                                    fontSize: wXD(20, context),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(
                              wXD(18, context),
                              wXD(20, context),
                              wXD(18, context),
                              wXD(18, context),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5,
                                    color: Color(0x40000000),
                                    offset: Offset.zero),
                              ],
                              color: Color(0xfffafafa),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Observer(
                                        builder: (context) => Container(
                                          margin: EdgeInsets.fromLTRB(
                                            wXD(15, context),
                                            wXD(25, context),
                                            wXD(15, context),
                                            wXD(25, context),
                                          ),
                                          height: wXD(120, context),
                                          width: wXD(120, context),
                                          child: InkWell(
                                            onTap: () async {
                                              await store.pickImage();
                                            },
                                            child: store.loadCircularAvatar
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : PersonPhoto(
                                                    photo: store
                                                        .mapPatient['avatar'],
                                                    borderColor:
                                                        Color(0xff41C3B3),
                                                    size: wXD(120, context),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: wXD(20, context),
                                        child: IconButton(
                                          onPressed: () {
                                            store.pickImage();
                                          },
                                          icon: Icon(
                                            Icons.camera_alt,
                                            size: wXD(38, context),
                                            color: Color(0xff41C3B3),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Observer(builder: (context) {
                                  return Visibility(
                                    visible: store.avatarError,
                                    child: Center(
                                      child: Text(
                                        'Selecione uma imagem!',
                                        style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                TitleWidget(
                                  title: 'Dados pessoais',
                                  top: wXD(13, context),
                                  bottom: wXD(13, context),
                                  left: wXD(8, context),
                                  style: TextStyle(
                                      color: Color(0xff41C3B3),
                                      fontSize: wXD(20, context),
                                      fontWeight: FontWeight.bold),
                                ),
                                DataTileProfile(
                                  type: 'username',
                                  focusNode: nameFocus,
                                  hint: 'Ex: Fulano',
                                  initialValue: store.mapPatient['username'],
                                  title: 'Nome de usuário',
                                  mandatory: true,
                                  onChanged: (String value) {
                                    store.mapPatient['username'] = value;
                                  },
                                  onEditingComplete: () {
                                    fullNameFocus.requestFocus();
                                  },
                                ),
                                DataTileProfile(
                                  type: 'fullname',
                                  focusNode: fullNameFocus,
                                  title: 'Nome completo',
                                  mandatory: true,
                                  hint: 'Ex: Fulano de tal',
                                  initialValue: store.mapPatient['fullname'],
                                  onChanged: (String value) {
                                    store.mapPatient['fullname'] = value;
                                  },
                                ),
                                DataTileProfile(
                                  type: 'birthday',
                                  focusNode: dateNacFocus,
                                  hint: store.converterDate(null, true),
                                  title: 'Data de nascimento*',
                                  iconTap: () => store.selectDate(context),
                                ),
                                DataTileProfile(
                                  type: 'cpf',
                                  focusNode: cpfFocus,
                                  hint: 'Ex: 999.999.999-99',
                                  initialValue: store.mapPatient['cpf'],
                                  title: 'CPF',
                                  mandatory: true,
                                  onChanged: (String value) {
                                    store.mapPatient['cpf'] = value;
                                  },
                                ),
                                DataTileProfile(
                                  type: 'gender',
                                  focusNode: genderFocus,
                                  hint: 'Ex: Feminino',
                                  mandatory: true,
                                  title: 'Gênero',
                                  iconTap: () {
                                    store.genderDialog = true;
                                  },
                                ),
                                TitleWidget(
                                  title: 'Dados de contato',
                                  top: wXD(13, context),
                                  bottom: wXD(13, context),
                                  left: wXD(8, context),
                                  style: TextStyle(
                                      color: Color(0xff41C3B3),
                                      fontSize: wXD(20, context),
                                      fontWeight: FontWeight.bold),
                                ),
                                DataTileProfile(
                                  type: 'phone',
                                  focusNode: phoneFocus,
                                  hint: 'Ex: +55 (99) 99999-9999',
                                  initialValue: store.mapPatient['phone'],
                                  title: 'Telefone',
                                ),
                                DataTileProfile(
                                  type: 'email',
                                  focusNode: emailFocus,
                                  hint: 'Ex: fulano@encontrarCuidado.com',
                                  initialValue: store.mapPatient['email'],
                                  title: 'E-mail',
                                  onChanged: (String value) {
                                    store.email = value;
                                  },
                                  onEditingComplete: () {
                                    emailFocus2.requestFocus();
                                  },
                                  mandatory: true,
                                ),
                                DataTileProfile(
                                  hint: 'Ex: fulano@gmail.com',
                                  initialValue: store.mapPatient['email'],
                                  title: 'Confirme o seu e-mail',
                                  type: 'email2',
                                  focusNode: emailFocus2,
                                  onChanged: (String value) {
                                    store.mapPatient['email'] = value;
                                  },
                                  onEditingComplete: () {
                                    cepFocus.requestFocus();
                                  },
                                  mandatory: true,
                                ),
                                TitleWidget(
                                  title: 'Endereço',
                                  top: wXD(13, context),
                                  bottom: wXD(13, context),
                                  left: wXD(8, context),
                                  style: TextStyle(
                                      color: Color(0xff41C3B3),
                                      fontSize: wXD(20, context),
                                      fontWeight: FontWeight.bold),
                                ),
                                DataTileProfile(
                                  type: 'cep',
                                  focusNode: cepFocus,
                                  hint: 'Ex: 99.999-999',
                                  initialValue: store.mapPatient['cep'],
                                  title: 'CEP',
                                  mandatory: true,
                                  onChanged: (String value) {
                                    store.mapPatient['cep'] = value;
                                  },
                                  onEditingComplete: () {
                                    addressFocus.requestFocus();
                                  },
                                ),
                                DataTileProfile(
                                  type: 'address',
                                  focusNode: addressFocus,
                                  hint: 'Exemplo: Rua 123, Quadra 321',
                                  initialValue: store.mapPatient['address'],
                                  title: 'Endereço',
                                  mandatory: true,
                                  onChanged: (String value) {
                                    store.mapPatient['address'] = value;
                                  },
                                  onEditingComplete: () {
                                    addressNumFocus.requestFocus();
                                  },
                                ),
                                DataTileProfile(
                                  type: 'numberAddress',
                                  focusNode: addressNumFocus,
                                  hint: 'Ex: 123',
                                  initialValue:
                                      store.mapPatient['number_address'],
                                  title: 'Número',
                                  onChanged: (String value) {
                                    store.mapPatient['number_address'] = value;
                                  },
                                  onEditingComplete: () {
                                    addressComplementFocus.requestFocus();
                                  },
                                  mandatory: true,
                                ),
                                DataTileProfile(
                                  type: 'complementAddress',
                                  focusNode: addressComplementFocus,
                                  hint: 'Ex: Na esquina da quadra',
                                  initialValue:
                                      store.mapPatient['complement_address'],
                                  title: 'Complemento',
                                  onChanged: (String value) {
                                    store.mapPatient['complement_address'] =
                                        value;
                                  },
                                  onEditingComplete: () {
                                    neighborhoodFocus.requestFocus();
                                  },
                                ),
                                DataTileProfile(
                                  type: 'neighborhood',
                                  focusNode: neighborhoodFocus,
                                  hint: 'Ex: Bairro feliz',
                                  initialValue:
                                      store.mapPatient['neighborhood'],
                                  title: 'Bairro',
                                  mandatory: true,
                                  onChanged: (String value) {
                                    store.mapPatient['neighborhood'] = value;
                                  },
                                  onEditingComplete: () {
                                    store.focusNodeState.requestFocus();
                                  },
                                ),
                                DataTileProfile(
                                  type: 'country',
                                  initialValue: store.mapPatient['country'],
                                  title: 'País',
                                  mandatory: true,
                                  iconTap: () {},
                                ),
                                DataTileProfile(
                                  type: 'state',
                                  focusNode: stateFocus,
                                  hint: 'Ex: DF',
                                  initialValue: store.mapPatient['state'],
                                  title: 'Estado',
                                  mandatory: true,
                                  onChanged: (String value) {
                                    store.mapPatient['state'] = value;
                                  },
                                  iconTap: () {
                                    if (!store.focusNodeState.hasFocus) {
                                      store.focusNodeState.requestFocus();
                                    } else {
                                      store.focusNodeState.unfocus();
                                    }
                                  },
                                ),
                                DataTileProfile(
                                  type: 'city',
                                  focusNode: cityFocus,
                                  hint: 'Ex: Brasília',
                                  initialValue: store.mapPatient['city'],
                                  title: 'Cidade',
                                  mandatory: true,
                                  onChanged: (String value) {
                                    store.mapPatient['city'] = value;
                                  },
                                  iconTap: () {
                                    if (!store.focusNodeCity.hasFocus) {
                                      store.focusNodeCity.requestFocus();
                                    } else {
                                      store.focusNodeCity.unfocus();
                                    }
                                  },
                                ),
                                Observer(builder: (context) {
                                  if (store.input) {
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
                                    height: store.input ? wXD(50, context) : 0,
                                  );
                                }),
                                SizedBox(
                                  height: wXD(10, context),
                                ),
                                Observer(
                                  builder: (context) {
                                    return store.loadCircularEdit
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  top: maxWidth * .025,
                                                  bottom: maxWidth * .07,
                                                ),
                                                height: maxWidth * .1493,
                                                width: maxWidth * .1493,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(90),
                                                ),
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ],
                                          )
                                        : Center(
                                            child: InkWell(
                                              onTap: () async {
                                                await store.getValidate();

                                                if (_formKey.currentState
                                                        .validate() &&
                                                    store.validEdit) {
                                                  store.confirmEdit(context);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Preencha os campos obrigatórios corretamente, inclusive a foto",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red[700],
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                  _scrollController
                                                      .jumpTo(0.00);
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  top: maxWidth * .025,
                                                  bottom: maxWidth * .07,
                                                ),
                                                height: maxWidth * .1493,
                                                width: maxWidth * .1493,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Color(0xff41C3B3),
                                                        Color(0xff21BCCE),
                                                      ],
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 6,
                                                        offset: Offset(0, 3),
                                                        color:
                                                            Color(0x30000000),
                                                      )
                                                    ]),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Color(0xfffafafa),
                                                  size: maxWidth * .1,
                                                ),
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ],
                            )),
                      ],
                    ),
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
                                          store.setGender(genders: listGender);
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
                                    return Center(
                                      child: Builder(
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              store.setGender(
                                                  genders: listGender,
                                                  clickItem: true,
                                                  itemName: i);
                                              store.genderDialog = false;
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        wXD(20, context)),
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
                                      ),
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
