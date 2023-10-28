import 'package:encontrarCuidado/app/modules/address/address_Page.dart';
import 'package:encontrarCuidado/app/modules/address/address_store.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AddressModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AddressStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => AddressPage()),
  ];

  @override
  Widget get view => throw AddressPage();
}
