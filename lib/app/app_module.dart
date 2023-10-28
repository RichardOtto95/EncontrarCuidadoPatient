import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:encontrarCuidado/app/core/modules/root/root_module.dart';
import 'package:encontrarCuidado/app/modules/feed/feed_store.dart';
import 'package:encontrarCuidado/app/modules/profile/profile_store.dart';
import 'package:encontrarCuidado/app/modules/schedule/schedule_store.dart';
import 'package:encontrarCuidado/app/modules/drprofile/drprofile_store.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/messages/messages_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'core/services/auth/auth_service.dart';
import 'core/services/auth/auth_store.dart';
import 'modules/schedulings/scheduling_store.dart';
import 'modules/search/search_store.dart';
import 'modules/sign/sign_store.dart';
import 'modules/specialty/specialty_store.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => MainStore()),
    Bind((i) => FeedStore()),
    Bind((i) => MessagesStore()),
    Bind((i) => DrProfileStore()),
    Bind((i) => ScheduleStore()),
    Bind((i) => SchedulingStore()),
    Bind((i) => ProfileStore()),
    Bind((i) => SpecialtyStore()),
    Bind((i) => SearchStore()),
    Bind<AuthService>((i) => AuthService()),
    Bind((i) => AuthStore()),
    Bind((i) => SignStore(i.get())),
    Bind<PatientModel>((i) => PatientModel()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: RootModule()),
  ];
}
