import 'package:encontrarCuidado/app/modules/messages/widgets/empty_state.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(children: [
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
                          size: maxWidth * 26 / 375,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    Text(
                      'Mensagens',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: wXD(20, context),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      EmptyStateList(
                        image:
                            'assets/img/Business, Technology, startup _ account, preferences, user, profile, settings, woman, graph, analysis.png',
                        title:
                            '''Envie e receba mensagens\ndos especialistas com quem\nvocê agendou consultas.''',
                      ),
                    ],
                  ),
                ),
              ),
              Row(children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: maxHeight * 1 / 375, left: maxWidth * 150 / 375),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Spacer(flex: 1),

                  // Spacer(flex: 1),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
