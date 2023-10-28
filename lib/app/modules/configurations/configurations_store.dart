import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'configurations_store.g.dart';

class ConfigurationsStore = _ConfigurationsStoreBase with _$ConfigurationsStore;

abstract class _ConfigurationsStoreBase with Store {
  final AuthStore authStore = Modular.get();

  @observable
  bool initialValueSwitch = false;

  @action
  switchValue(bool changed) async {
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();

    if (changed) {
      _user.reference
          .update({'notification_disabled': !_user['notification_disabled']});
      initialValueSwitch = !initialValueSwitch;
    } else {
      initialValueSwitch = _user['notification_disabled'];
    }
  }
}
