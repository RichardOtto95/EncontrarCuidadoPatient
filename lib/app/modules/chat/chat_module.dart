import 'package:encontrarCuidado/app/modules/chat/chat_page.dart';
import 'package:encontrarCuidado/app/modules/chat/chat_store.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ChatStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => ChatPage()),
  ];

  @override
  Widget get view => ChatPage();
}
