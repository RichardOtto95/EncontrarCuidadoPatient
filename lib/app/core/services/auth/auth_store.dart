import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:encontrarCuidado/app/core/modules/root/root_store.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_service_interface.dart';
import 'package:encontrarCuidado/app/core/utils/auth_status_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  _AuthStoreBase() {
    _authService.handleGetUser().then(setUser);
  }

  final AuthServiceInterface _authService = Modular.get();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RootStore rootController = Modular.get();
  @observable
  AuthStatus status = AuthStatus.loading;
  @observable
  String userVerifyId;
  @observable
  String phoneMobile;
  @observable
  String mobile;
  @observable
  bool linked = false;
  @observable
  User user;
  @observable
  bool codeSent = false;
  @observable
  PatientModel patientBD;
  @action
  setCodeSent(bool _valc) => codeSent = _valc;
  @action
  setLinked(bool _vald) => linked = _vald;
  @action
  setUser(User value) {
    user = value;
    status = user == null ? AuthStatus.signed_out : AuthStatus.signed_in;
  }

  @action
  Future signinWithGoogle() async {
    await _authService.handleGoogleSignin();
  }

  @action
  Future linkAccountGoogle() async {
    await _authService.handleLinkAccountGoogle(user);
  }

  // @action
  // Future getUser() async {
  //   user = await _authService.handleGetUser();
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .get()
  //       .then((value) {
  //     // //print'dentro do then  ${value.data['firstName']}');
  //     patientBD = PatientModel.fromDocument(value);
  //     // user = ;
  //     // //print'depois do fromDocument  $user');

  //     return user;
  //   });
  // }

  @action
  Future signup(PatientModel patient) async {
    patient = await _authService.handleSignup(patient);
  }

  @action
  Future siginEmail(String email, String password) async {
    user = await _authService.handleEmailSignin(email, password);
  }

  @action
  Future signout() async {
    setUser(null);
    return _authService.handleSetSignout();
  }

  @action
  Future sentSMS(String userPhone) async {
    return _authService.verifyNumber(userPhone);
  }

  @action
  Future signinSMS(String smsCode, String verify) async {
    return _authService.handleSmsSignin(smsCode, verify);
  }

  @action
  Future verifyNumber(String userPhone, Function callBackError) async {
    String verifID;
    var phoneMobile = '+55' + userPhone;
    // print('phne ===$phoneMobile');
    mobile = userPhone;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneMobile,

      // timeout: Duration(seconds: 60),
      timeout: Duration(seconds: 20),
      verificationCompleted: (AuthCredential authCredential) {
        // print('authCredential: =================$authCredential');

        //code for signing in}).catchError((e){
        FirebaseFirestore.instance
            .collection('patients')
            .where('mobile_phone_number', isEqualTo: userPhone)
            .snapshots()
            .map((queryResults) {
          return queryResults.docs.map((doc) {}).toList();
        });

        _auth
            .signInWithCredential(authCredential)
            .then((UserCredential result) {})
            .catchError((e) {
          print(e);
        });
        // //printe);
      },
      verificationFailed: (FirebaseAuthException authException) {
        print(
            '%%%%%%%%%%%%%%%%%%%%% verification failed %%%%%%%%%%%%%%%%%%%%%');
        print(authException.message);
        print(authException.code);

        callBackError(authException.code);
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        userVerifyId = verificationId;
        codeSent = true;
        setCodeSent(true);
        Modular.to.pushNamed('/phone-verify');
        //print"Código enviado para " + userPhone);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // ForceResendingToken from callbacks

        verificationId = verificationId;
        //printverificationId);
        //print"Timout");
      },
      // timeout: Duration(seconds: 60),
    );
    return verifID;
  }

  // @action
  // Future<FirebaseUser> handleLinkSmsSignin(
  //     String smsCode, String userVerifyId) async {
  //   final AuthCredential credential = PhoneAuthProvider.getCredential(
  //       verificationId: userVerifyId, smsCode: smsCode);

  //   FirebaseUser _user = (await user.linkWithCredential(credential)).user;
  //   return _user;
  // }

  @action
  Future<User> handleSmsSignin(String smsCode, String verificationId) async {
    print('%%%%%%%% handleSmsSignin %%%%%%%%');

    // print('credential: =================$verificationId');
    // print('credential: =================$smsCode');

    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    // print('credential: =================$credential');
    try {
      final User _user = (await _auth.signInWithCredential(credential)).user;
      user = _user;
      // print('user: =================$_user');

      // await FirebaseAuth.instance
      //     .signInWithCredential(credential)
      //     .then((authResult) {
      //   print('KKKKKKKKKKKKKKKKKKKKKK${authResult.user}');
      // });
      // final User user = (await _auth.signInWithCredential(credential)).user;
      return _user;
    } catch (e) {
      print('%%%%%%%%% error: $e %%%%%%%%%%%');
      Fluttertoast.showToast(
          msg: "Código inválido!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
  }
}
