import 'package:encontrarCuidado/app/core/modules/root/root_Page.dart';
import 'package:encontrarCuidado/app/core/modules/root/root_store.dart';
import 'package:encontrarCuidado/app/modules/address/address_module.dart';
import 'package:encontrarCuidado/app/modules/configurations/configurations_module.dart';
import 'package:encontrarCuidado/app/modules/dependents/dependents_module.dart';
import 'package:encontrarCuidado/app/modules/drprofile/drprofile_page.dart';
import 'package:encontrarCuidado/app/modules/feed/feed_module.dart';
import 'package:encontrarCuidado/app/modules/feed/report.dart';
// import 'package:encontrarCuidado/app/modules/drprofile/drprofile_module.dart';
import 'package:encontrarCuidado/app/modules/main/main_module.dart';
import 'package:encontrarCuidado/app/modules/messages/messages_module.dart';
import 'package:encontrarCuidado/app/modules/payment/payment_module.dart';
import 'package:encontrarCuidado/app/modules/profile/profile_module.dart';
import 'package:encontrarCuidado/app/modules/schedulings/consulation_details.dart';
import 'package:encontrarCuidado/app/modules/schedule/schedule_module.dart';
import 'package:encontrarCuidado/app/modules/schedulings/scheduling_module.dart';
import 'package:encontrarCuidado/app/modules/search/search_module.dart';
import 'package:encontrarCuidado/app/modules/sign/sign_module.dart';
import 'package:encontrarCuidado/app/modules/sign/sign_page_verify.dart';
import 'package:encontrarCuidado/app/modules/specialty/specialtie.dart';
import 'package:encontrarCuidado/app/modules/specialty/specialty_module.dart';
import 'package:encontrarCuidado/app/modules/suport/suport_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RootModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RootStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => RootPage()),
    ModuleRoute('/address', module: AddressModule()),
    ModuleRoute('/configurations', module: ConfigurationsModule()),
    ModuleRoute('/feed', module: FeedModule()),
    ModuleRoute('/main', module: MainModule()),
    ModuleRoute('/specialty', module: SpecialtyModule()),
    ModuleRoute('/scheduling', module: SchedulingModule()),
    ModuleRoute('/schedule', module: ScheduleModule()),
    ModuleRoute('/messages', module: MessagesModule()),
    ModuleRoute('/search', module: SearchModule()),
    ChildRoute('/drprofile',
        child: (_, args) => DrProfilePage(
              doctorModel: args.data,
            )),
    ChildRoute('/consulation-detail',
        child: (_, args) => ConsulationDetail(
              appointmentModel: args.data,
            )),
    // ChildRoute('/drprofile-hard', child: (_, args) => DrProfilePageHard()),
    ModuleRoute('/profile', module: ProfileModule()),
    ModuleRoute('/payment', module: PaymentModule()),
    ModuleRoute('/dependents', module: DependentsModule()),
    ModuleRoute('/suport', module: SuportModule()),
    ChildRoute('/phone-verify', child: (_, args) => SignVerifyPage()),
    ModuleRoute('/sign', module: SignModule()),
    ChildRoute('/specialists',
        child: (_, args) => Specialtie(
              specId: args.data,
            )),
    ChildRoute('/report',
        child: (_, args) => Report(
              feedId: args.data,
            )),
  ];
}
