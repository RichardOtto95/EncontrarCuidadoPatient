import 'package:encontrarCuidado/app/modules/suport/suport_Page.dart';
import 'package:encontrarCuidado/app/modules/suport/suport_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SuportModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SuportStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SuportPage()),
  ];
}
