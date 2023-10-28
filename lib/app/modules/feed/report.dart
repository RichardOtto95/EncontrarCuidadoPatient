import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../shared/widgets/encontrar_cuidado._navbar.dart';
import '../../shared/widgets/report_tile.dart';
import 'feed_store.dart';

class Report extends StatefulWidget {
  final String feedId;

  const Report({
    Key key,
    this.feedId,
  }) : super(key: key);
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final FeedStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    print('xxxxxxxxxx build report ${widget.feedId} xxxxxxxxxxxxx');
    return WillPopScope(
      onWillPop: () async {
        store.reportingPost = false;

        mainStore.showNavigator = true;
        return true;
      },
      child: Scaffold(
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
                          store.reportingPost = false;

                          mainStore.showNavigator = true;
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
                      'Reportar postagem',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: wXD(20, context),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: wXD(15, context),
                  bottom: wXD(20, context),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: wXD(28, context),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selecione um motivo para reportar essa postagem:',
                  style: TextStyle(
                    fontSize: wXD(12, context),
                    color: Color(0xaa707070),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0x40707070),
                      width: 1,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  mainStore.showNavigator = true;
                  store.reportingToReported(
                      'offensive', widget.feedId, context);
                  // setState(() {});
                },
                child: ReportTile(
                  text: 'Acho ofensivo',
                ),
              ),
              InkWell(
                onTap: () {
                  mainStore.showNavigator = true;
                  store.reportingToReported('spam', widget.feedId, context);
                },
                child: ReportTile(
                  text: 'É spam',
                ),
              ),
              InkWell(
                onTap: () {
                  mainStore.showNavigator = true;
                  store.reportingToReported(
                      'sexually inappropriate', widget.feedId, context);
                },
                child: ReportTile(
                  text: 'Inclui conteúdo sexualmente inadequado',
                ),
              ),
              InkWell(
                onTap: () {
                  mainStore.showNavigator = true;
                  store.reportingToReported('a scheme', widget.feedId, context);
                },
                child: ReportTile(
                  text: 'É um golpe ou é enganoso',
                ),
              ),
              InkWell(
                onTap: () {
                  mainStore.showNavigator = true;
                  store.reportingToReported(
                      'violent or forbidden', widget.feedId, context);
                },
                child: ReportTile(
                  text: 'O conteúdo é violento ou proibido',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
