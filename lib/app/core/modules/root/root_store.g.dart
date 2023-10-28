// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RootStore on _RootStoreBase, Store {
  final _$valueAtom = Atom(name: '_RootStoreBase.value');

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

  final _$selectedTrunkAtom = Atom(name: '_RootStoreBase.selectedTrunk');

  @override
  int get selectedTrunk {
    _$selectedTrunkAtom.reportRead();
    return super.selectedTrunk;
  }

  @override
  set selectedTrunk(int value) {
    _$selectedTrunkAtom.reportWrite(value, super.selectedTrunk, () {
      super.selectedTrunk = value;
    });
  }

  final _$bucketGlobalAtom = Atom(name: '_RootStoreBase.bucketGlobal');

  @override
  PageStorageBucket get bucketGlobal {
    _$bucketGlobalAtom.reportRead();
    return super.bucketGlobal;
  }

  @override
  set bucketGlobal(PageStorageBucket value) {
    _$bucketGlobalAtom.reportWrite(value, super.bucketGlobal, () {
      super.bucketGlobal = value;
    });
  }

  final _$_RootStoreBaseActionController =
      ActionController(name: '_RootStoreBase');

  @override
  dynamic setBucket(PageStorageBucket bck) {
    final _$actionInfo = _$_RootStoreBaseActionController.startAction(
        name: '_RootStoreBase.setBucket');
    try {
      return super.setBucket(bck);
    } finally {
      _$_RootStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSelectedTrunk(int value) {
    final _$actionInfo = _$_RootStoreBaseActionController.startAction(
        name: '_RootStoreBase.setSelectedTrunk');
    try {
      return super.setSelectedTrunk(value);
    } finally {
      _$_RootStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$_RootStoreBaseActionController.startAction(
        name: '_RootStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$_RootStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
selectedTrunk: ${selectedTrunk},
bucketGlobal: ${bucketGlobal}
    ''';
  }
}
