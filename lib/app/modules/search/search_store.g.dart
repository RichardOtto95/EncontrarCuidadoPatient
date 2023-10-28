// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SearchStore on _SearchStoreBase, Store {
  final _$cityAtom = Atom(name: '_SearchStoreBase.city');

  @override
  String get city {
    _$cityAtom.reportRead();
    return super.city;
  }

  @override
  set city(String value) {
    _$cityAtom.reportWrite(value, super.city, () {
      super.city = value;
    });
  }

  final _$specialityAtom = Atom(name: '_SearchStoreBase.speciality');

  @override
  String get speciality {
    _$specialityAtom.reportRead();
    return super.speciality;
  }

  @override
  set speciality(String value) {
    _$specialityAtom.reportWrite(value, super.speciality, () {
      super.speciality = value;
    });
  }

  final _$specialityIDAtom = Atom(name: '_SearchStoreBase.specialityID');

  @override
  String get specialityID {
    _$specialityIDAtom.reportRead();
    return super.specialityID;
  }

  @override
  set specialityID(String value) {
    _$specialityIDAtom.reportWrite(value, super.specialityID, () {
      super.specialityID = value;
    });
  }

  final _$substr1Atom = Atom(name: '_SearchStoreBase.substr1');

  @override
  ObservableList<dynamic> get substr1 {
    _$substr1Atom.reportRead();
    return super.substr1;
  }

  @override
  set substr1(ObservableList<dynamic> value) {
    _$substr1Atom.reportWrite(value, super.substr1, () {
      super.substr1 = value;
    });
  }

  final _$substr2Atom = Atom(name: '_SearchStoreBase.substr2');

  @override
  List<dynamic> get substr2 {
    _$substr2Atom.reportRead();
    return super.substr2;
  }

  @override
  set substr2(List<dynamic> value) {
    _$substr2Atom.reportWrite(value, super.substr2, () {
      super.substr2 = value;
    });
  }

  final _$patientDocAtom = Atom(name: '_SearchStoreBase.patientDoc');

  @override
  DocumentSnapshot<Object> get patientDoc {
    _$patientDocAtom.reportRead();
    return super.patientDoc;
  }

  @override
  set patientDoc(DocumentSnapshot<Object> value) {
    _$patientDocAtom.reportWrite(value, super.patientDoc, () {
      super.patientDoc = value;
    });
  }

  final _$nextTapAtom = Atom(name: '_SearchStoreBase.nextTap');

  @override
  bool get nextTap {
    _$nextTapAtom.reportRead();
    return super.nextTap;
  }

  @override
  set nextTap(bool value) {
    _$nextTapAtom.reportWrite(value, super.nextTap, () {
      super.nextTap = value;
    });
  }

  final _$startWithIndexAtom = Atom(name: '_SearchStoreBase.startWithIndex');

  @override
  int get startWithIndex {
    _$startWithIndexAtom.reportRead();
    return super.startWithIndex;
  }

  @override
  set startWithIndex(int value) {
    _$startWithIndexAtom.reportWrite(value, super.startWithIndex, () {
      super.startWithIndex = value;
    });
  }

  final _$localAtom = Atom(name: '_SearchStoreBase.local');

  @override
  String get local {
    _$localAtom.reportRead();
    return super.local;
  }

  @override
  set local(String value) {
    _$localAtom.reportWrite(value, super.local, () {
      super.local = value;
    });
  }

  final _$locControllerAtom = Atom(name: '_SearchStoreBase.locController');

  @override
  TextEditingController get locController {
    _$locControllerAtom.reportRead();
    return super.locController;
  }

  @override
  set locController(TextEditingController value) {
    _$locControllerAtom.reportWrite(value, super.locController, () {
      super.locController = value;
    });
  }

  final _$spcControllerAtom = Atom(name: '_SearchStoreBase.spcController');

  @override
  TextEditingController get spcController {
    _$spcControllerAtom.reportRead();
    return super.spcController;
  }

  @override
  set spcController(TextEditingController value) {
    _$spcControllerAtom.reportWrite(value, super.spcController, () {
      super.spcController = value;
    });
  }

  final _$firstLookAtom = Atom(name: '_SearchStoreBase.firstLook');

  @override
  bool get firstLook {
    _$firstLookAtom.reportRead();
    return super.firstLook;
  }

  @override
  set firstLook(bool value) {
    _$firstLookAtom.reportWrite(value, super.firstLook, () {
      super.firstLook = value;
    });
  }

  final _$specialitiesAtom = Atom(name: '_SearchStoreBase.specialities');

  @override
  QuerySnapshot<Object> get specialities {
    _$specialitiesAtom.reportRead();
    return super.specialities;
  }

  @override
  set specialities(QuerySnapshot<Object> value) {
    _$specialitiesAtom.reportWrite(value, super.specialities, () {
      super.specialities = value;
    });
  }

  final _$getLocationAsyncAction = AsyncAction('_SearchStoreBase.getLocation');

  @override
  Future getLocation(String locate) {
    return _$getLocationAsyncAction.run(() => super.getLocation(locate));
  }

  final _$localSearchAsyncAction = AsyncAction('_SearchStoreBase.localSearch');

  @override
  Future localSearch(String search, int length) {
    return _$localSearchAsyncAction
        .run(() => super.localSearch(search, length));
  }

  final _$specialSearchAsyncAction =
      AsyncAction('_SearchStoreBase.specialSearch');

  @override
  Future specialSearch(String search, int length) {
    return _$specialSearchAsyncAction
        .run(() => super.specialSearch(search, length));
  }

  final _$viewDrProfileAsyncAction =
      AsyncAction('_SearchStoreBase.viewDrProfile');

  @override
  Future viewDrProfile(String doctorId) {
    return _$viewDrProfileAsyncAction.run(() => super.viewDrProfile(doctorId));
  }

  final _$_SearchStoreBaseActionController =
      ActionController(name: '_SearchStoreBase');

  @override
  dynamic setNextTap() {
    final _$actionInfo = _$_SearchStoreBaseActionController.startAction(
        name: '_SearchStoreBase.setNextTap');
    try {
      return super.setNextTap();
    } finally {
      _$_SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSpecialtyID(String spc) {
    final _$actionInfo = _$_SearchStoreBaseActionController.startAction(
        name: '_SearchStoreBase.setSpecialtyID');
    try {
      return super.setSpecialtyID(spc);
    } finally {
      _$_SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSpecialty(String spc) {
    final _$actionInfo = _$_SearchStoreBaseActionController.startAction(
        name: '_SearchStoreBase.setSpecialty');
    try {
      return super.setSpecialty(spc);
    } finally {
      _$_SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLocation(String lc) {
    final _$actionInfo = _$_SearchStoreBaseActionController.startAction(
        name: '_SearchStoreBase.setLocation');
    try {
      return super.setLocation(lc);
    } finally {
      _$_SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLength(int lg) {
    final _$actionInfo = _$_SearchStoreBaseActionController.startAction(
        name: '_SearchStoreBase.setLength');
    try {
      return super.setLength(lg);
    } finally {
      _$_SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic resetLocal() {
    final _$actionInfo = _$_SearchStoreBaseActionController.startAction(
        name: '_SearchStoreBase.resetLocal');
    try {
      return super.resetLocal();
    } finally {
      _$_SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
city: ${city},
speciality: ${speciality},
specialityID: ${specialityID},
substr1: ${substr1},
substr2: ${substr2},
patientDoc: ${patientDoc},
nextTap: ${nextTap},
startWithIndex: ${startWithIndex},
local: ${local},
locController: ${locController},
spcController: ${spcController},
firstLook: ${firstLook},
specialities: ${specialities}
    ''';
  }
}
