// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AuthStore on _AuthStoreBase, Store {
  final _$statusAtom = Atom(name: '_AuthStoreBase.status');

  @override
  AuthStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(AuthStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$userVerifyIdAtom = Atom(name: '_AuthStoreBase.userVerifyId');

  @override
  String get userVerifyId {
    _$userVerifyIdAtom.reportRead();
    return super.userVerifyId;
  }

  @override
  set userVerifyId(String value) {
    _$userVerifyIdAtom.reportWrite(value, super.userVerifyId, () {
      super.userVerifyId = value;
    });
  }

  final _$phoneMobileAtom = Atom(name: '_AuthStoreBase.phoneMobile');

  @override
  String get phoneMobile {
    _$phoneMobileAtom.reportRead();
    return super.phoneMobile;
  }

  @override
  set phoneMobile(String value) {
    _$phoneMobileAtom.reportWrite(value, super.phoneMobile, () {
      super.phoneMobile = value;
    });
  }

  final _$mobileAtom = Atom(name: '_AuthStoreBase.mobile');

  @override
  String get mobile {
    _$mobileAtom.reportRead();
    return super.mobile;
  }

  @override
  set mobile(String value) {
    _$mobileAtom.reportWrite(value, super.mobile, () {
      super.mobile = value;
    });
  }

  final _$linkedAtom = Atom(name: '_AuthStoreBase.linked');

  @override
  bool get linked {
    _$linkedAtom.reportRead();
    return super.linked;
  }

  @override
  set linked(bool value) {
    _$linkedAtom.reportWrite(value, super.linked, () {
      super.linked = value;
    });
  }

  final _$userAtom = Atom(name: '_AuthStoreBase.user');

  @override
  User get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$codeSentAtom = Atom(name: '_AuthStoreBase.codeSent');

  @override
  bool get codeSent {
    _$codeSentAtom.reportRead();
    return super.codeSent;
  }

  @override
  set codeSent(bool value) {
    _$codeSentAtom.reportWrite(value, super.codeSent, () {
      super.codeSent = value;
    });
  }

  final _$patientBDAtom = Atom(name: '_AuthStoreBase.patientBD');

  @override
  PatientModel get patientBD {
    _$patientBDAtom.reportRead();
    return super.patientBD;
  }

  @override
  set patientBD(PatientModel value) {
    _$patientBDAtom.reportWrite(value, super.patientBD, () {
      super.patientBD = value;
    });
  }

  final _$signinWithGoogleAsyncAction =
      AsyncAction('_AuthStoreBase.signinWithGoogle');

  @override
  Future<dynamic> signinWithGoogle() {
    return _$signinWithGoogleAsyncAction.run(() => super.signinWithGoogle());
  }

  final _$linkAccountGoogleAsyncAction =
      AsyncAction('_AuthStoreBase.linkAccountGoogle');

  @override
  Future<dynamic> linkAccountGoogle() {
    return _$linkAccountGoogleAsyncAction.run(() => super.linkAccountGoogle());
  }

  final _$signupAsyncAction = AsyncAction('_AuthStoreBase.signup');

  @override
  Future<dynamic> signup(PatientModel patient) {
    return _$signupAsyncAction.run(() => super.signup(patient));
  }

  final _$siginEmailAsyncAction = AsyncAction('_AuthStoreBase.siginEmail');

  @override
  Future<dynamic> siginEmail(String email, String password) {
    return _$siginEmailAsyncAction.run(() => super.siginEmail(email, password));
  }

  final _$signoutAsyncAction = AsyncAction('_AuthStoreBase.signout');

  @override
  Future<dynamic> signout() {
    return _$signoutAsyncAction.run(() => super.signout());
  }

  final _$sentSMSAsyncAction = AsyncAction('_AuthStoreBase.sentSMS');

  @override
  Future<dynamic> sentSMS(String userPhone) {
    return _$sentSMSAsyncAction.run(() => super.sentSMS(userPhone));
  }

  final _$signinSMSAsyncAction = AsyncAction('_AuthStoreBase.signinSMS');

  @override
  Future<dynamic> signinSMS(String smsCode, String verify) {
    return _$signinSMSAsyncAction.run(() => super.signinSMS(smsCode, verify));
  }

  final _$verifyNumberAsyncAction = AsyncAction('_AuthStoreBase.verifyNumber');

  @override
  Future<dynamic> verifyNumber(String userPhone, Function callBackError) {
    return _$verifyNumberAsyncAction
        .run(() => super.verifyNumber(userPhone, callBackError));
  }

  final _$handleSmsSigninAsyncAction =
      AsyncAction('_AuthStoreBase.handleSmsSignin');

  @override
  Future<User> handleSmsSignin(String smsCode, String verificationId) {
    return _$handleSmsSigninAsyncAction
        .run(() => super.handleSmsSignin(smsCode, verificationId));
  }

  final _$_AuthStoreBaseActionController =
      ActionController(name: '_AuthStoreBase');

  @override
  dynamic setCodeSent(bool _valc) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.setCodeSent');
    try {
      return super.setCodeSent(_valc);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLinked(bool _vald) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.setLinked');
    try {
      return super.setLinked(_vald);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUser(User value) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.setUser');
    try {
      return super.setUser(value);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
userVerifyId: ${userVerifyId},
phoneMobile: ${phoneMobile},
mobile: ${mobile},
linked: ${linked},
user: ${user},
codeSent: ${codeSent},
patientBD: ${patientBD}
    ''';
  }
}
