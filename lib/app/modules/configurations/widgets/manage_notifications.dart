import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../configurations_store.dart';

class ManageNotifications extends StatefulWidget {
  @override
  _ManageNotificationsState createState() => _ManageNotificationsState();
}

class _ManageNotificationsState extends State<ManageNotifications> {
  final ConfigurationsStore store = Modular.get();

  @override
  void initState() {
    store.switchValue(false);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EncontrarCuidadoNavBar(
              leading: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: wXD(11, context), right: wXD(11, context)),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: wXD(26, context),
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  Text(
                    'Gerenciar notificações',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: wXD(20, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: wXD(20, context),
                vertical: wXD(20, context),
              ),
              child: Row(
                children: [
                  Text(
                    'Silenciar Notificações',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: wXD(19, context),
                        fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  Observer(
                    builder: (context) {
                      return Switch(
                        value: store.initialValueSwitch,
                        onChanged: (value) {
                          store.switchValue(true);
                        },
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
