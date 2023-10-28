import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../drprofile_store.dart';

class Report extends StatefulWidget {
  final postId;

  const Report({Key key, this.postId}) : super(key: key);
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    final DrProfileStore store = Modular.get();

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
                store.reportPost('offensive', widget.postId);
              },
              child: ReportTile(
                text: 'Acho ofensivo',
              ),
            ),
            InkWell(
              onTap: () {
                store.reportPost('spam', widget.postId);
              },
              child: ReportTile(
                text: 'É spam',
              ),
            ),
            InkWell(
              onTap: () {
                store.reportPost('sexually inappropriate', widget.postId);
              },
              child: ReportTile(
                text: 'Inclui conteúdo sexualmente inadequado',
              ),
            ),
            InkWell(
              onTap: () {
                store.reportPost('a scheme', widget.postId);
              },
              child: ReportTile(
                text: 'É um golpe ou é enganoso',
              ),
            ),
            InkWell(
              onTap: () {
                store.reportPost('violent or forbidden', widget.postId);
              },
              child: ReportTile(
                text: 'O conteúdo é violento ou proibido',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportTile extends StatelessWidget {
  final String text;
  final double top;
  final double bottom;
  final double horizontal;
  final double fontSize;
  final FontWeight fontWeight;
  final Color iconColor;
  final Function onTap;

  const ReportTile({
    Key key,
    this.text,
    this.top = 18,
    this.bottom = 13,
    this.horizontal = 28,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.iconColor = const Color(0x80707070),
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          top: wXD(top, context),
          bottom: wXD(bottom, context),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: wXD(horizontal, context),
        ),
        child: Row(
          children: [
            Text(
              '$text',
              style: TextStyle(
                fontSize: wXD(fontSize, context),
                color: Color(0xff707070),
                fontWeight: fontWeight,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: wXD(15, context),
              color: iconColor,
            ),
          ],
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
    );
  }
}
