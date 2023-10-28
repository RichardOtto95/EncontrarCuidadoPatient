import 'package:encontrarCuidado/app/modules/configurations/configurations_Page.dart';
import 'package:encontrarCuidado/app/modules/configurations/configurations_store.dart';
import 'package:encontrarCuidado/app/modules/configurations/widgets/app_info.dart';
import 'package:encontrarCuidado/app/modules/configurations/widgets/manage_notifications.dart';
import 'package:encontrarCuidado/app/modules/configurations/widgets/use_terms.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/privacy_policy.dart';

class ConfigurationsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ConfigurationsStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => ConfigurationsPage()),
    ChildRoute('/app-info', child: (_, args) => Appinfo()),
    ChildRoute('/manage-notifications',
        child: (_, args) => ManageNotifications()),
    ChildRoute('/use-terms', child: (_, args) => UseTerms()),
    ChildRoute('/privacy-policy', child: (_, args) => PrivacyPolicy()),
  ];
}
