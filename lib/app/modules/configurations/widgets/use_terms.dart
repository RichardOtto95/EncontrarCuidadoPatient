import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/configurations/configurations_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UseTerms extends StatefulWidget {
  @override
  _UseTermsState createState() => _UseTermsState();
}

class _UseTermsState extends State<UseTerms> {
  final ConfigurationsStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Termos de uso',
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: wXD(20, context),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('info')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        print(
                            'snapshot: ${snapshot.data.docs[0]['Terms_of_use']}');
                        // snapshot.docudata['Terms_of_use'];
                        return SfPdfViewer.network(
                          '${snapshot.data.docs[0]['Terms_of_use']}',
                          // canShowScrollStatus: false,
                          canShowScrollHead: false,
                        );
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
