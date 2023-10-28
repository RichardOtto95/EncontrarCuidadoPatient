import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:encontrarCuidado/app/modules/configurations/configurations_store.dart';
import 'package:flutter/material.dart';

import 'widgets/perfil_till.dart';

class ConfigurationsPage extends StatefulWidget {
  final String title;
  const ConfigurationsPage({Key key, this.title = 'ConfigurationsPage'})
      : super(key: key);
  @override
  ConfigurationsPageState createState() => ConfigurationsPageState();
}

class ConfigurationsPageState extends State<ConfigurationsPage> {
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
                        size: maxWidth(context) * 26 / 375,
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  Text(
                    'Configurações',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: wXD(20, context),
                    ),
                  ),
                ],
              ),
            ),
            PerfilTill(
              onTap: () {
                Modular.to.pushNamed('/configurations/manage-notifications');
              },
              title: 'Gerenciar Notificações',
              icon: Icons.notifications_none,
            ),
            PerfilTill(
              onTap: () {
                Modular.to.pushNamed('/configurations/app-info');
              },
              title: 'Informações do App',
              icon: Icons.info,
            ),
            PerfilTill(
              onTap: () {
                Modular.to.pushNamed('/configurations/use-terms');
              },
              title: 'Termos de uso',
              icon: Icons.article_rounded,
            ),
            PerfilTill(
              onTap: () {
                Modular.to.pushNamed('/configurations/privacy-policy');
              },
              title: 'Política de privacidade',
              icon: Icons.lock,
            ),
            Spacer(
              flex: 8,
            ),
            Image.asset(
              'assets/img/Grupo de máscara 1.png',
              height: wXD(47, context),
            ),
            Spacer(
              flex: 1,
            ),
            Text(
              'Versão 1.0',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xff707070).withOpacity(.6),
                fontSize: wXD(20, context),
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
