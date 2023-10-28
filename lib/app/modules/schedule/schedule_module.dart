import 'package:encontrarCuidado/app/modules/schedule/schedule_page.dart';
import 'package:encontrarCuidado/app/modules/schedule/schedule_store.dart';
import 'package:encontrarCuidado/app/modules/schedulings/widgets/reschedule.dart';
import 'package:encontrarCuidado/app/modules/specialty/widgets/confirm_appointment.dart';
import 'package:encontrarCuidado/app/shared/widgets/confirmation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ScheduleModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ScheduleStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SchedulePage(group: args)),
    ChildRoute('/confirm-appointment',
        child: (_, args) => ConfirmAppointment()),
    ChildRoute('/confirmation', child: (_, args) => Confirmation()),
    ChildRoute('/reschedule', child: (_, args) => Reschedule()),
  ];

  @override
  Widget get view => SchedulePage();
}
