import 'dart:async';

import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:encontrarCuidado/app/modules/sign/sign_store.dart';
import 'package:encontrarCuidado/app/shared/color_theme.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignVerifyPage extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<SignVerifyPage> {
  final SignStore store = Modular.get();
  final AuthStore authStore = Modular.get();

  bool secondResend = false;
  FocusNode firstNode;
  FocusNode secondFocusNode;
  FocusNode thirdFocusNode;
  FocusNode fouthFocusNode;
  FocusNode fiveFocusNode;
  FocusNode sixFocusNode;
  String currentText = "";
  bool loadCircular = false;
  Timer _timer;
  int _start = 60;
  @override
  void initState() {
    super.initState();
    firstNode = FocusNode();
    secondFocusNode = FocusNode();
    thirdFocusNode = FocusNode();
    fouthFocusNode = FocusNode();
    fiveFocusNode = FocusNode();
    sixFocusNode = FocusNode();
    // messageListener();
  }

  @override
  void dispose() {
    firstNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fouthFocusNode.dispose();
    fiveFocusNode.dispose();
    sixFocusNode.dispose();
    print('%%%%%%%% TIMER $_timer ');
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }
    super.dispose();
  }

  // void messageListener() {
  //   FirebaseAuth.instance.idTokenChanges().listen((firebaseUser) async {
  //     print('%%%%%%%%% messageListener() $firebaseUser %%%%%%%%%');
  //     if (firebaseUser != null) {
  //       var _user = await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(firebaseUser.uid)
  //           .get();
  //       print('%%%%%%%%% _user() $_user %%%%%%%%%');
  //       if (_user != null) {
  //         // Modular.to.pushNamed('/');
  //         // rootController.setSelectedTrunk(2);
  //         // rootController.setSelectIndexPage(1);

  //       } else {
  //         // controller.user.mobile_region_code =
  //         //     firebaseUser.phoneNumber.substring(3, 5);
  //         // controller.user.mobile_phone_number =
  //         //     firebaseUser.phoneNumber.substring(5, 14);
  //         // await authService.handleSignup(controller.user);
  //         // await authService.handleGetUser();
  //         // Modular.to.pushNamed('/');
  //         // rootController.setSelectedTrunk(2);
  //         // rootController.setSelectIndexPage(1);
  //       }
  //     }
  //   });
  // }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            print('*************8 reenviou');
            print(
                '*************authStore.phoneMobile ${authStore.phoneMobile}');
            print('*************authStore.mobile ${authStore.mobile}');

            store.phone = authStore.mobile;
            store.verifyNumber();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void startTimereNumber() {
    const oneSec = const Duration(seconds: 1);
    store.timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (store.start == 0) {
          setState(() {
            store.timer.cancel();
            print('##################### reenviou');
            print(
                '#####################3 authStore.phoneMobile ${authStore.phoneMobile}');
            print('#####################authStore.mobile ${authStore.mobile}');
          });
        } else {
          setState(() {
            store.start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        store.start = 60;
        if (_timer != null) {
          if (_timer.isActive) {
            _timer.cancel();
          }
        }
        startTimereNumber();
        store.loadCircularPhone = false;
        store.setUserPhone("");
        Modular.to.pushNamed('/');
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: maxWidth,
              ),
              Spacer(
                flex: 1,
              ),
              Container(
                child: Image.asset(
                  'assets/img/grupo_43.png',
                  height: wXD(67, context),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Container(
                child: Text(
                  'Código enviado',
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: maxWidth * .1066,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Insira o código \nabaixo',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: maxWidth * .0826,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(
                flex: 2,
              ),
              Container(
                  width: maxWidth * .704,
                  child: PinCodeTextField(
                    keyboardType: TextInputType.number,
                    length: 6,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        fieldHeight: 50,
                        fieldWidth: 40,
                        inactiveColor: Colors.grey[400], //
                        activeColor: Color(0xFF41c3b3),
                        selectedColor: Color(0xff21bcce)),
                    backgroundColor: ColorTheme.white,
                    animationDuration: Duration(milliseconds: 300),
                    onCompleted: (value) async {
                      store.loadCircularVerify = true;

                      await store.signinPhone(
                        store.code,
                        authStore.userVerifyId,
                      );
                    },
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                        store.code = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  )),
              Spacer(
                flex: 1,
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (store.loadCircularVerify == false) {
                    if (_timer == null) startTimer();
                    setState(() {
                      secondResend = true;
                    });
                  }
                },
                child: Text(
                  "Reenviar código",
                  style: TextStyle(
                    fontSize: maxWidth * .048,
                    fontWeight: FontWeight.normal,
                    color: Color(0xff646464),
                  ),
                ),
                shape: Border(
                  bottom: BorderSide(
                    width: 3.0,
                    color: Color(0xFF2185D0),
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              secondResend
                  ? Text(
                      "Reenviando código em ${_start} segundos",
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal),
                    )
                  : Container(),
              Spacer(
                flex: 1,
              ),
              Observer(
                builder: (context) {
                  return store.loadCircularVerify
                      ? CircularProgressIndicator()
                      : InkWell(
                          onTap: () async {
                            if (currentText.length == 6 &&
                                currentText.isNotEmpty) {
                              store.loadCircularVerify = true;

                              await store.signinPhone(
                                store.code,
                                authStore.userVerifyId,
                              );
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Digite o código enviado por completo!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Container(
                            width: maxWidth * .6826,
                            height: maxWidth * .1386,
                            alignment: Alignment.center,
                            child: Text(
                              'Validar',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(23)),
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
                        );
                },
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
