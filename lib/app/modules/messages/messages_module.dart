import 'package:encontrarCuidado/app/modules/messages/messages_Page.dart';
import 'package:encontrarCuidado/app/modules/messages/messages_store.dart';
import 'package:encontrarCuidado/app/modules/messages/widgets/chat.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MessagesModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => MessagesStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => MessagesPage()),
    ChildRoute('/chat', child: (_, args) => Chat()),
  ];

  @override
  Widget get view => MessagesPage();
}
