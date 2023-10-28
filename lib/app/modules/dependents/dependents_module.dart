import 'package:encontrarCuidado/app/modules/dependents/dependents_Page.dart';
import 'package:encontrarCuidado/app/modules/dependents/dependents_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/add_dependent.dart';
import 'widgets/dependent.dart';

class DependentsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => DependentsStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => DependentsPage()),
    ChildRoute('/add-dependent', child: (_, args) => AddDependent()),
    ChildRoute('/dependent',
        child: (_, args) => Dependent(
              dependent: args.data,
            )),
  ];
}
