// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configurations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConfigurationsStore on _ConfigurationsStoreBase, Store {
  final _$initialValueSwitchAtom =
      Atom(name: '_ConfigurationsStoreBase.initialValueSwitch');

  @override
  bool get initialValueSwitch {
    _$initialValueSwitchAtom.reportRead();
    return super.initialValueSwitch;
  }

  @override
  set initialValueSwitch(bool value) {
    _$initialValueSwitchAtom.reportWrite(value, super.initialValueSwitch, () {
      super.initialValueSwitch = value;
    });
  }

  final _$switchValueAsyncAction =
      AsyncAction('_ConfigurationsStoreBase.switchValue');

  @override
  Future switchValue(bool changed) {
    return _$switchValueAsyncAction.run(() => super.switchValue(changed));
  }

  @override
  String toString() {
    return '''
initialValueSwitch: ${initialValueSwitch}
    ''';
  }
}
