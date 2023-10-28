import 'package:mobx/mobx.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStoreBase with _$ChatStore;
abstract class _ChatStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}