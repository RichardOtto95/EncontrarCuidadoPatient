// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignStore on _SignStoreBase, Store {
  final _$valueAtom = Atom(name: '_SignStoreBase.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$phoneAtom = Atom(name: '_SignStoreBase.phone');

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  final _$codeAtom = Atom(name: '_SignStoreBase.code');

  @override
  String get code {
    _$codeAtom.reportRead();
    return super.code;
  }

  @override
  set code(String value) {
    _$codeAtom.reportWrite(value, super.code, () {
      super.code = value;
    });
  }

  final _$loadCircularPhoneAtom =
      Atom(name: '_SignStoreBase.loadCircularPhone');

  @override
  bool get loadCircularPhone {
    _$loadCircularPhoneAtom.reportRead();
    return super.loadCircularPhone;
  }

  @override
  set loadCircularPhone(bool value) {
    _$loadCircularPhoneAtom.reportWrite(value, super.loadCircularPhone, () {
      super.loadCircularPhone = value;
    });
  }

  final _$loadCircularVerifyAtom =
      Atom(name: '_SignStoreBase.loadCircularVerify');

  @override
  bool get loadCircularVerify {
    _$loadCircularVerifyAtom.reportRead();
    return super.loadCircularVerify;
  }

  @override
  set loadCircularVerify(bool value) {
    _$loadCircularVerifyAtom.reportWrite(value, super.loadCircularVerify, () {
      super.loadCircularVerify = value;
    });
  }

  final _$timerAtom = Atom(name: '_SignStoreBase.timer');

  @override
  Timer get timer {
    _$timerAtom.reportRead();
    return super.timer;
  }

  @override
  set timer(Timer value) {
    _$timerAtom.reportWrite(value, super.timer, () {
      super.timer = value;
    });
  }

  final _$startAtom = Atom(name: '_SignStoreBase.start');

  @override
  int get start {
    _$startAtom.reportRead();
    return super.start;
  }

  @override
  set start(int value) {
    _$startAtom.reportWrite(value, super.start, () {
      super.start = value;
    });
  }

  final _$signinPhoneAsyncAction = AsyncAction('_SignStoreBase.signinPhone');

  @override
  Future signinPhone(String _code, String verifyId) {
    return _$signinPhoneAsyncAction
        .run(() => super.signinPhone(_code, verifyId));
  }

  final _$_SignStoreBaseActionController =
      ActionController(name: '_SignStoreBase');

  @override
  dynamic setUserPhone(String telephone) {
    final _$actionInfo = _$_SignStoreBaseActionController.startAction(
        name: '_SignStoreBase.setUserPhone');
    try {
      return super.setUserPhone(telephone);
    } finally {
      _$_SignStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$_SignStoreBaseActionController.startAction(
        name: '_SignStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$_SignStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUserCode(String _userd) {
    final _$actionInfo = _$_SignStoreBaseActionController.startAction(
        name: '_SignStoreBase.setUserCode');
    try {
      return super.setUserCode(_userd);
    } finally {
      _$_SignStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
phone: ${phone},
code: ${code},
loadCircularPhone: ${loadCircularPhone},
loadCircularVerify: ${loadCircularVerify},
timer: ${timer},
start: ${start}
    ''';
  }
}
