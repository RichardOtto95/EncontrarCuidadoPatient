import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:encontrarCuidado/app/modules/main/main_module.dart';
import 'package:encontrarCuidado/app/modules/sign/sign_page_phone.dart';
import 'package:encontrarCuidado/app/modules/sign/sign_store.dart';
import 'package:encontrarCuidado/app/modules/sign/widgets/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SignStore(i.get())),
    Bind<PatientModel>((i) => PatientModel()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => SignPhonePage()),
    ChildRoute("/phone", child: (_, args) => SignPhonePage()),
    ChildRoute("/boarding", child: (_, args) => OnBoarding()),
    ModuleRoute('/main', module: MainModule()),
  ];

  @override
  Widget get view => SignPhonePage();
}
