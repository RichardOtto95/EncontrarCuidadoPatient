import 'package:encontrarCuidado/app/modules/payment/payment_Page.dart';
import 'package:encontrarCuidado/app/modules/payment/payment_store.dart';
import 'package:encontrarCuidado/app/modules/payment/widgets/add_card.dart';
import 'package:encontrarCuidado/app/modules/payment/widgets/transaction_detail.dart';
import 'package:encontrarCuidado/app/modules/profile/widgets/edit_profile.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'widgets/card_data.dart';

class PaymentModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => PaymentStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => PaymentPage()),
    ChildRoute('/transaction', child: (_, args) => TransactionDetail()),
    ChildRoute('/add-card',
        child: (_, args) => AddCard(
              hasCard: args.data,
            )),
    ChildRoute('/card-data',
        child: (_, args) => CardData(
              cardModel: args.data,
            )),
    // ModuleRoute('/profile', module: ProfileModule()),
    ChildRoute('/edit-profile',
        child: (_, args) => EditProfile(
              patientModel: args.data,
            )),
  ];
}
