import 'package:mobx/mobx.dart';

part 'address_store.g.dart';

class AddressStore = _AddressStoreBase with _$AddressStore;
abstract class _AddressStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}