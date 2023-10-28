import 'package:encontrarCuidado/app/modules/profile/profile_Page.dart';
import 'package:encontrarCuidado/app/modules/profile/profile_store.dart';

import 'package:encontrarCuidado/app/modules/profile/widgets/edit_profile.dart';
import 'package:encontrarCuidado/app/modules/profile/widgets/notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ProfileStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => ProfilePage()),
    ChildRoute('/edit-profile',
        child: (_, args) => EditProfile(
              patientModel: args.data,
            )),
    ChildRoute('/notifications', child: (_, args) => Notifications()),
  ];
}
