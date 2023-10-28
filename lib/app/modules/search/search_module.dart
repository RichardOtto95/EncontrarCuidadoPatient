import 'package:encontrarCuidado/app/modules/search/search_Page.dart';
import 'package:encontrarCuidado/app/modules/search/search_store.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SearchStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SearchPage()),
  ];

  @override
  Widget get view => SearchPage();
}
