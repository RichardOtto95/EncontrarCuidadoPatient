import 'package:encontrarCuidado/app/modules/specialty/specialtie.dart';
import 'package:encontrarCuidado/app/modules/specialty/specialty_Page.dart';
import 'package:encontrarCuidado/app/modules/specialty/specialty_store.dart';
import 'package:encontrarCuidado/app/modules/specialty/widgets/confirm_appointment.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SpecialtyModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SpecialtyStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SpecialtyPage()),
    ChildRoute('/confirm-appointment',
        child: (_, args) => ConfirmAppointment(
              boolRouterConsulationDetail: args.data,
            )),
  ];

  @override
  Widget get view => SpecialtyPage();
}
