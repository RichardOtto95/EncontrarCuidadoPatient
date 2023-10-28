import 'package:encontrarCuidado/app/modules/feed/feed_Page.dart';
import 'package:encontrarCuidado/app/modules/feed/feed_store.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FeedModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => FeedStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => FeedPage()),
  ];

  @override
  Widget get view => FeedPage();
}
