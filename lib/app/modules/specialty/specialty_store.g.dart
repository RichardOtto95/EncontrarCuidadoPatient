// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialty_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SpecialtyStore on _SpecialtyStoreBase, Store {
  final _$valueAtom = Atom(name: '_SpecialtyStoreBase.value');

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

  final _$editingAtom = Atom(name: '_SpecialtyStoreBase.editing');

  @override
  bool get editing {
    _$editingAtom.reportRead();
    return super.editing;
  }

  @override
  set editing(bool value) {
    _$editingAtom.reportWrite(value, super.editing, () {
      super.editing = value;
    });
  }

  final _$showMenuFilterAtom = Atom(name: '_SpecialtyStoreBase.showMenuFilter');

  @override
  bool get showMenuFilter {
    _$showMenuFilterAtom.reportRead();
    return super.showMenuFilter;
  }

  @override
  set showMenuFilter(bool value) {
    _$showMenuFilterAtom.reportWrite(value, super.showMenuFilter, () {
      super.showMenuFilter = value;
    });
  }

  final _$specialityAtom = Atom(name: '_SpecialtyStoreBase.speciality');

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

  final _$mapRatingsAtom = Atom(name: '_SpecialtyStoreBase.mapRatings');

  @override
  ObservableMap<dynamic, dynamic> get mapRatings {
    _$mapRatingsAtom.reportRead();
    return super.mapRatings;
  }

  @override
  set mapRatings(ObservableMap<dynamic, dynamic> value) {
    _$mapRatingsAtom.reportWrite(value, super.mapRatings, () {
      super.mapRatings = value;
    });
  }

  final _$listDoctorsAtom = Atom(name: '_SpecialtyStoreBase.listDoctors');

  @override
  ObservableList<dynamic> get listDoctors {
    _$listDoctorsAtom.reportRead();
    return super.listDoctors;
  }

  @override
  set listDoctors(ObservableList<dynamic> value) {
    _$listDoctorsAtom.reportWrite(value, super.listDoctors, () {
      super.listDoctors = value;
    });
  }

  final _$indexFilterAtom = Atom(name: '_SpecialtyStoreBase.indexFilter');

  @override
  int get indexFilter {
    _$indexFilterAtom.reportRead();
    return super.indexFilter;
  }

  @override
  set indexFilter(int value) {
    _$indexFilterAtom.reportWrite(value, super.indexFilter, () {
      super.indexFilter = value;
    });
  }

  final _$setCardsAtom = Atom(name: '_SpecialtyStoreBase.setCards');

  @override
  bool get setCards {
    _$setCardsAtom.reportRead();
    return super.setCards;
  }

  @override
  set setCards(bool value) {
    _$setCardsAtom.reportWrite(value, super.setCards, () {
      super.setCards = value;
    });
  }

  final _$onEditingAtom = Atom(name: '_SpecialtyStoreBase.onEditing');

  @override
  bool get onEditing {
    _$onEditingAtom.reportRead();
    return super.onEditing;
  }

  @override
  set onEditing(bool value) {
    _$onEditingAtom.reportWrite(value, super.onEditing, () {
      super.onEditing = value;
    });
  }

  final _$getDoctorsAsyncAction = AsyncAction('_SpecialtyStoreBase.getDoctors');

  @override
  Future getDoctors(String specId) {
    return _$getDoctorsAsyncAction.run(() => super.getDoctors(specId));
  }

  final _$viewDrProfileAsyncAction =
      AsyncAction('_SpecialtyStoreBase.viewDrProfile');

  @override
  Future viewDrProfile(String doctorId) {
    return _$viewDrProfileAsyncAction.run(() => super.viewDrProfile(doctorId));
  }

  final _$_SpecialtyStoreBaseActionController =
      ActionController(name: '_SpecialtyStoreBase');

  @override
  dynamic setEditing(bool value) {
    final _$actionInfo = _$_SpecialtyStoreBaseActionController.startAction(
        name: '_SpecialtyStoreBase.setEditing');
    try {
      return super.setEditing(value);
    } finally {
      _$_SpecialtyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCardDialog(bool c) {
    final _$actionInfo = _$_SpecialtyStoreBaseActionController.startAction(
        name: '_SpecialtyStoreBase.setCardDialog');
    try {
      return super.setCardDialog(c);
    } finally {
      _$_SpecialtyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOnEditing(bool value) {
    final _$actionInfo = _$_SpecialtyStoreBaseActionController.startAction(
        name: '_SpecialtyStoreBase.setOnEditing');
    try {
      return super.setOnEditing(value);
    } finally {
      _$_SpecialtyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getRatings(String doctorId) {
    final _$actionInfo = _$_SpecialtyStoreBaseActionController.startAction(
        name: '_SpecialtyStoreBase.getRatings');
    try {
      return super.getRatings(doctorId);
    } finally {
      _$_SpecialtyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic fixSpec() {
    final _$actionInfo = _$_SpecialtyStoreBaseActionController.startAction(
        name: '_SpecialtyStoreBase.fixSpec');
    try {
      return super.fixSpec();
    } finally {
      _$_SpecialtyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
editing: ${editing},
showMenuFilter: ${showMenuFilter},
speciality: ${speciality},
mapRatings: ${mapRatings},
listDoctors: ${listDoctors},
indexFilter: ${indexFilter},
setCards: ${setCards},
onEditing: ${onEditing}
    ''';
  }
}
