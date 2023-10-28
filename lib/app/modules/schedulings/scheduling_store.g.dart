// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduling_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SchedulingStore on _SchedulingStoreBase, Store {
  final _$pageAtom = Atom(name: '_SchedulingStoreBase.page');

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  final _$addressAtom = Atom(name: '_SchedulingStoreBase.address');

  @override
  String get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  final _$listSchedulesAtom = Atom(name: '_SchedulingStoreBase.listSchedules');

  @override
  ObservableList<dynamic> get listSchedules {
    _$listSchedulesAtom.reportRead();
    return super.listSchedules;
  }

  @override
  set listSchedules(ObservableList<dynamic> value) {
    _$listSchedulesAtom.reportWrite(value, super.listSchedules, () {
      super.listSchedules = value;
    });
  }

  final _$querySchedulesAtom =
      Atom(name: '_SchedulingStoreBase.querySchedules');

  @override
  QuerySnapshot<Object> get querySchedules {
    _$querySchedulesAtom.reportRead();
    return super.querySchedules;
  }

  @override
  set querySchedules(QuerySnapshot<Object> value) {
    _$querySchedulesAtom.reportWrite(value, super.querySchedules, () {
      super.querySchedules = value;
    });
  }

  final _$showDialogAtom = Atom(name: '_SchedulingStoreBase.showDialog');

  @override
  bool get showDialog {
    _$showDialogAtom.reportRead();
    return super.showDialog;
  }

  @override
  set showDialog(bool value) {
    _$showDialogAtom.reportWrite(value, super.showDialog, () {
      super.showDialog = value;
    });
  }

  final _$confirmOverlayAtom =
      Atom(name: '_SchedulingStoreBase.confirmOverlay');

  @override
  OverlayEntry get confirmOverlay {
    _$confirmOverlayAtom.reportRead();
    return super.confirmOverlay;
  }

  @override
  set confirmOverlay(OverlayEntry value) {
    _$confirmOverlayAtom.reportWrite(value, super.confirmOverlay, () {
      super.confirmOverlay = value;
    });
  }

  final _$mapStatusAtom = Atom(name: '_SchedulingStoreBase.mapStatus');

  @override
  ObservableMap<dynamic, dynamic> get mapStatus {
    _$mapStatusAtom.reportRead();
    return super.mapStatus;
  }

  @override
  set mapStatus(ObservableMap<dynamic, dynamic> value) {
    _$mapStatusAtom.reportWrite(value, super.mapStatus, () {
      super.mapStatus = value;
    });
  }

  final _$_SchedulingStoreBaseActionController =
      ActionController(name: '_SchedulingStoreBase');

  @override
  dynamic getAddress(String doctorId) {
    final _$actionInfo = _$_SchedulingStoreBaseActionController.startAction(
        name: '_SchedulingStoreBase.getAddress');
    try {
      return super.getAddress(doctorId);
    } finally {
      _$_SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getHour(Timestamp hour) {
    final _$actionInfo = _$_SchedulingStoreBaseActionController.startAction(
        name: '_SchedulingStoreBase.getHour');
    try {
      return super.getHour(hour);
    } finally {
      _$_SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getDate(Timestamp date) {
    final _$actionInfo = _$_SchedulingStoreBaseActionController.startAction(
        name: '_SchedulingStoreBase.getDate');
    try {
      return super.getDate(date);
    } finally {
      _$_SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
page: ${page},
address: ${address},
listSchedules: ${listSchedules},
querySchedules: ${querySchedules},
showDialog: ${showDialog},
confirmOverlay: ${confirmOverlay},
mapStatus: ${mapStatus}
    ''';
  }
}
