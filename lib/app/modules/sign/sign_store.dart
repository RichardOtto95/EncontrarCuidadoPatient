import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:encontrarCuidado/app/core/modules/root/root_store.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_service_interface.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';

part 'sign_store.g.dart';

class SignStore = _SignStoreBase with _$SignStore;

abstract class _SignStoreBase with Store {
  final AuthStore authStore = Modular.get();
  final RootStore rootStore = Modular.get();
  final PatientModel patient;
  AuthServiceInterface authService = Modular.get();

  User valueUser;
  User sadasda;
  @observable
  int value = 0;
  @observable
  String phone = '';
  @observable
  String code;
  @observable
  bool loadCircularPhone = false;
  @observable
  bool loadCircularVerify = false;
  @observable
  Timer timer;
  @observable
  int start = 60;
  _SignStoreBase(this.patient);
  @action
  setUserPhone(String telephone) => phone = telephone;
  @action
  void increment() {
    value++;
  }

  void verifyNumber() async {
    print('##### phone $phone');
    String userPhone = '+55' + phone;
    print('##### userPhone $userPhone');
    QuerySnapshot _doctors = await FirebaseFirestore.instance
        .collection('doctors')
        .where('phone', isEqualTo: userPhone)
        .get();
    QuerySnapshot _admins = await FirebaseFirestore.instance
        .collection('admins')
        .where('mobile_full_number', isEqualTo: userPhone)
        .get();
    QuerySnapshot _patients = await FirebaseFirestore.instance
        .collection('patients')
        .where('phone', isEqualTo: userPhone)
        .where('type', isEqualTo: 'HOLDER')
        .get();
    print("_patients.length: ${_patients.docs.length}");
    if (_doctors.docs.isNotEmpty || _admins.docs.isNotEmpty) {
      Fluttertoast.showToast(
          msg:
              "Esse número de usuário não tem permissão para acessar este aplicativo",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[700],
          textColor: Colors.white,
          fontSize: 16.0);
      loadCircularPhone = false;
    } else if (_patients.docs.isNotEmpty &&
        _patients.docs.first.get("status") == "BLOCKED") {
      print("_patients.status: ${_patients.docs.first["status"]}");
      loadCircularPhone = false;
      Fluttertoast.showToast(
          msg: "Este usuário está bloqueado!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[700],
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      authStore.verifyNumber(phone, (String errorCode) {
        print('%%%%%%%%%%%%% callback $errorCode');
        loadCircularPhone = false;

        if (errorCode == 'invalid-phone-number') {
          Fluttertoast.showToast(
              msg: "Número inválido!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red[700],
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  }

  @action
  setUserCode(String _userd) => code = _userd;
  @action
  signinPhone(String _code, String verifyId) async {
    print('%%%%%%%% signinPhone %%%%%%%%');
    authStore.handleSmsSignin(_code, verifyId).then((value) async {
      print('%%%%%%%% signinPhone2 $value %%%%%%%%');

      // print('value: ${value.uid}');

      if (value != null) {
        // print('value.uid: ${value.uid}');

        valueUser = value;
        DocumentSnapshot _user = await FirebaseFirestore.instance
            .collection('patients')
            .doc(value.uid)
            .get();
        // print('_user db ${_user.exists}');
        // String token = await FirebaseMessaging.instance.getToken();
        // print('tokenId: $token');
        // _user.reference.update({
        //   'token_id': FieldValue.arrayUnion([token])
        // });

        if (_user.exists) {
          print('%%%%%%%% signinPhone _user.exists == true  %%%%%%%%');

          String tokenString = await FirebaseMessaging.instance.getToken();
          print('tokenId: $tokenString');
          await _user.reference.update({
            'token_id': FieldValue.arrayUnion([tokenString]),
          });

          // print('nao nullo');
          Modular.to.pushNamed('/main');
        } else {
          print('%%%%%%%% signinPhone _user.exists == false  %%%%%%%%');

          // print('nullo');
          patient.phone = value.phoneNumber;
          await authService.handleSignup(patient);
          await Modular.to.pushNamed('/sign/boarding');
        }
      } else {
        loadCircularVerify = false;
      }
    });
  }
}
