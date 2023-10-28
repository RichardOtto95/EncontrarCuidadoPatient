import 'package:encontrarCuidado/app/modules/sign/sign_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'widgets/masktextinputformatter.dart';

class SignPhonePage extends StatefulWidget {
  @override
  _SignPhonePage createState() => _SignPhonePage();
}

var maskFormatter = new MaskTextInputFormatter(
    mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

class _SignPhonePage extends State<SignPhonePage> {
  final SignStore store = Modular.get();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.loadCircularPhone = false;
      store.loadCircularVerify = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('HAHAHAHAHHAHA: ${store.phone}');

    double maxWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: maxWidth,
              ),
              Spacer(
                flex: 1,
              ),
              Container(
                child: Image.asset(
                  'assets/img/logotipo.png',
                  height: maxWidth * .30,
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Container(
                child: Text(
                  'Bem Vindo!',
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: maxWidth * .1066,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Cadastre-se\npara entrar',
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
                  width: wXD(186, context),
                  child: TextFormField(
                    initialValue: maskFormatter.maskText(store.phone),
                    onEditingComplete: () {
                      if (store.phone.length < 11) {
                        Fluttertoast.showToast(
                            msg: "Número incompleto!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        if (store.start != 60 && store.start != 0) {
                          store.loadCircularPhone = false;
                          Fluttertoast.showToast(
                              msg:
                                  "Aguarde ${store.start} segundos para reenviar um novo código",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          store.loadCircularPhone = true;
                          FocusScope.of(context).requestFocus(new FocusNode());
                          store.verifyNumber();
                        }
                      }
                    },
                    inputFormatters: [maskFormatter],
                    onChanged: (text) {
                      text = maskFormatter.getUnmaskedText();
                      // print('Telefone: value: $text');
                      store.setUserPhone(text);
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 15,
                    decoration: InputDecoration(
                        hintText: '(61)99999-9999',
                        hintStyle: TextStyle(
                          color: const Color(0xff707070),
                          fontSize: 20,
                        ),
                        counterText: "",
                        labelText: 'Telefone',
                        labelStyle: TextStyle(
                          color: const Color(0xff707070),
                          fontSize: 20,
                        )),
                  )),
              Spacer(flex: 1),
              Observer(
                builder: (context) => store.start != 60 && store.start != 0
                    ? Text(
                        "Aguarde ${store.start} segundos para reenviar um novo código",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      )
                    : Container(),
              ),
              Spacer(flex: 1),
              Observer(builder: (context) {
                return store.loadCircularPhone
                    ? CircularProgressIndicator()
                    : InkWell(
                        onTap: () {
                          if (store.phone.length < 11) {
                            Fluttertoast.showToast(
                                msg: "Digite o número por completo!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            if (store.start != 60 && store.start != 0) {
                              store.loadCircularPhone = false;

                              Fluttertoast.showToast(
                                  msg:
                                      "Aguarde ${store.start} segundos para reenviar um novo código",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              store.loadCircularPhone = true;

                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              store.verifyNumber();
                            }
                          }
                        },
                        child: Container(
                          width: maxWidth * .6826,
                          height: maxWidth * .1386,
                          alignment: Alignment.center,
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                                fontSize: wXD(20, context),
                                color: Colors.white),
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
                      );
              }),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
