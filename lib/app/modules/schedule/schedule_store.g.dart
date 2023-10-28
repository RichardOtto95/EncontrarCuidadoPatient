// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ScheduleStore on _ScheduleStoreBase, Store {
  final _$doctorAtom = Atom(name: '_ScheduleStoreBase.doctor');

  @override
  DoctorModel get doctor {
    _$doctorAtom.reportRead();
    return super.doctor;
  }

  @override
  set doctor(DoctorModel value) {
    _$doctorAtom.reportWrite(value, super.doctor, () {
      super.doctor = value;
    });
  }

  final _$schedulerSelectedAtom =
      Atom(name: '_ScheduleStoreBase.schedulerSelected');

  @override
  SchedulerModel get schedulerSelected {
    _$schedulerSelectedAtom.reportRead();
    return super.schedulerSelected;
  }

  @override
  set schedulerSelected(SchedulerModel value) {
    _$schedulerSelectedAtom.reportWrite(value, super.schedulerSelected, () {
      super.schedulerSelected = value;
    });
  }

  final _$allIsEmptyAtom = Atom(name: '_ScheduleStoreBase.allIsEmpty');

  @override
  bool get allIsEmpty {
    _$allIsEmptyAtom.reportRead();
    return super.allIsEmpty;
  }

  @override
  set allIsEmpty(bool value) {
    _$allIsEmptyAtom.reportWrite(value, super.allIsEmpty, () {
      super.allIsEmpty = value;
    });
  }

  final _$emptyStateAtom = Atom(name: '_ScheduleStoreBase.emptyState');

  @override
  bool get emptyState {
    _$emptyStateAtom.reportRead();
    return super.emptyState;
  }

  @override
  set emptyState(bool value) {
    _$emptyStateAtom.reportWrite(value, super.emptyState, () {
      super.emptyState = value;
    });
  }

  final _$onEditingAtom = Atom(name: '_ScheduleStoreBase.onEditing');

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

  final _$greedSymptomsAtom = Atom(name: '_ScheduleStoreBase.greedSymptoms');

  @override
  bool get greedSymptoms {
    _$greedSymptomsAtom.reportRead();
    return super.greedSymptoms;
  }

  @override
  set greedSymptoms(bool value) {
    _$greedSymptomsAtom.reportWrite(value, super.greedSymptoms, () {
      super.greedSymptoms = value;
    });
  }

  final _$firstScheduleAtom = Atom(name: '_ScheduleStoreBase.firstSchedule');

  @override
  bool get firstSchedule {
    _$firstScheduleAtom.reportRead();
    return super.firstSchedule;
  }

  @override
  set firstSchedule(bool value) {
    _$firstScheduleAtom.reportWrite(value, super.firstSchedule, () {
      super.firstSchedule = value;
    });
  }

  final _$scheduleCircularAtom =
      Atom(name: '_ScheduleStoreBase.scheduleCircular');

  @override
  bool get scheduleCircular {
    _$scheduleCircularAtom.reportRead();
    return super.scheduleCircular;
  }

  @override
  set scheduleCircular(bool value) {
    _$scheduleCircularAtom.reportWrite(value, super.scheduleCircular, () {
      super.scheduleCircular = value;
    });
  }

  final _$noteAtom = Atom(name: '_ScheduleStoreBase.note');

  @override
  String get note {
    _$noteAtom.reportRead();
    return super.note;
  }

  @override
  set note(String value) {
    _$noteAtom.reportWrite(value, super.note, () {
      super.note = value;
    });
  }

  final _$patientNameAtom = Atom(name: '_ScheduleStoreBase.patientName');

  @override
  String get patientName {
    _$patientNameAtom.reportRead();
    return super.patientName;
  }

  @override
  set patientName(String value) {
    _$patientNameAtom.reportWrite(value, super.patientName, () {
      super.patientName = value;
    });
  }

  final _$countyNumAtom = Atom(name: '_ScheduleStoreBase.countyNum');

  @override
  String get countyNum {
    _$countyNumAtom.reportRead();
    return super.countyNum;
  }

  @override
  set countyNum(String value) {
    _$countyNumAtom.reportWrite(value, super.countyNum, () {
      super.countyNum = value;
    });
  }

  final _$phoneAtom = Atom(name: '_ScheduleStoreBase.phone');

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

  final _$dependentIdAtom = Atom(name: '_ScheduleStoreBase.dependentId');

  @override
  String get dependentId {
    _$dependentIdAtom.reportRead();
    return super.dependentId;
  }

  @override
  set dependentId(String value) {
    _$dependentIdAtom.reportWrite(value, super.dependentId, () {
      super.dependentId = value;
    });
  }

  final _$priceAtom = Atom(name: '_ScheduleStoreBase.price');

  @override
  double get price {
    _$priceAtom.reportRead();
    return super.price;
  }

  @override
  set price(double value) {
    _$priceAtom.reportWrite(value, super.price, () {
      super.price = value;
    });
  }

  final _$nextDateAtom = Atom(name: '_ScheduleStoreBase.nextDate');

  @override
  DateTime get nextDate {
    _$nextDateAtom.reportRead();
    return super.nextDate;
  }

  @override
  set nextDate(DateTime value) {
    _$nextDateAtom.reportWrite(value, super.nextDate, () {
      super.nextDate = value;
    });
  }

  final _$visibleDatesAtom = Atom(name: '_ScheduleStoreBase.visibleDates');

  @override
  ObservableList<dynamic> get visibleDates {
    _$visibleDatesAtom.reportRead();
    return super.visibleDates;
  }

  @override
  set visibleDates(ObservableList<dynamic> value) {
    _$visibleDatesAtom.reportWrite(value, super.visibleDates, () {
      super.visibleDates = value;
    });
  }

  final _$schedulersAtom = Atom(name: '_ScheduleStoreBase.schedulers');

  @override
  ObservableList<dynamic> get schedulers {
    _$schedulersAtom.reportRead();
    return super.schedulers;
  }

  @override
  set schedulers(ObservableList<dynamic> value) {
    _$schedulersAtom.reportWrite(value, super.schedulers, () {
      super.schedulers = value;
    });
  }

  final _$firstSchedulersAtom =
      Atom(name: '_ScheduleStoreBase.firstSchedulers');

  @override
  ObservableList<dynamic> get firstSchedulers {
    _$firstSchedulersAtom.reportRead();
    return super.firstSchedulers;
  }

  @override
  set firstSchedulers(ObservableList<dynamic> value) {
    _$firstSchedulersAtom.reportWrite(value, super.firstSchedulers, () {
      super.firstSchedulers = value;
    });
  }

  final _$centerSchedulersAtom =
      Atom(name: '_ScheduleStoreBase.centerSchedulers');

  @override
  ObservableList<dynamic> get centerSchedulers {
    _$centerSchedulersAtom.reportRead();
    return super.centerSchedulers;
  }

  @override
  set centerSchedulers(ObservableList<dynamic> value) {
    _$centerSchedulersAtom.reportWrite(value, super.centerSchedulers, () {
      super.centerSchedulers = value;
    });
  }

  final _$lastSchedulersAtom = Atom(name: '_ScheduleStoreBase.lastSchedulers');

  @override
  ObservableList<dynamic> get lastSchedulers {
    _$lastSchedulersAtom.reportRead();
    return super.lastSchedulers;
  }

  @override
  set lastSchedulers(ObservableList<dynamic> value) {
    _$lastSchedulersAtom.reportWrite(value, super.lastSchedulers, () {
      super.lastSchedulers = value;
    });
  }

  final _$_ScheduleStoreBaseActionController =
      ActionController(name: '_ScheduleStoreBase');

  @override
  dynamic setSchedulers(dynamic _schedulers) {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.setSchedulers');
    try {
      return super.setSchedulers(_schedulers);
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAllIsEmpty(dynamic _allIsEmpty) {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.setAllIsEmpty');
    try {
      return super.setAllIsEmpty(_allIsEmpty);
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOnEditing(bool _onEditing) {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.setOnEditing');
    try {
      return super.setOnEditing(_onEditing);
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setGreedSymptoms(bool _greedSymptoms) {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.setGreedSymptoms');
    try {
      return super.setGreedSymptoms(_greedSymptoms);
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFirstSchedule(bool _firstSchedule) {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.setFirstSchedule');
    try {
      return super.setFirstSchedule(_firstSchedule);
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setNote(String _note) {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.setNote');
    try {
      return super.setNote(_note);
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPatientName(String _patientName) {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.setPatientName');
    try {
      return super.setPatientName(_patientName);
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setVisibleDates(DateTime _date) {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.setVisibleDates');
    try {
      return super.setVisibleDates(_date);
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setVisibleSchedulers() {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.setVisibleSchedulers');
    try {
      return super.setVisibleSchedulers();
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
doctor: ${doctor},
schedulerSelected: ${schedulerSelected},
allIsEmpty: ${allIsEmpty},
emptyState: ${emptyState},
onEditing: ${onEditing},
greedSymptoms: ${greedSymptoms},
firstSchedule: ${firstSchedule},
scheduleCircular: ${scheduleCircular},
note: ${note},
patientName: ${patientName},
countyNum: ${countyNum},
phone: ${phone},
dependentId: ${dependentId},
price: ${price},
nextDate: ${nextDate},
visibleDates: ${visibleDates},
schedulers: ${schedulers},
firstSchedulers: ${firstSchedulers},
centerSchedulers: ${centerSchedulers},
lastSchedulers: ${lastSchedulers}
    ''';
  }
}
