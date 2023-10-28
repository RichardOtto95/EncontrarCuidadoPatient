import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/specialty/specialty_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/report_tile.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SpecialtyPage extends StatefulWidget {
  final String title;
  const SpecialtyPage({Key key, this.title = 'SpecialtyPage'})
      : super(key: key);
  @override
  SpecialtyPageState createState() => SpecialtyPageState();
}

class SpecialtyPageState extends ModularState<SpecialtyPage, SpecialtyStore> {
  final MainStore mainStore = Modular.get();

  ScrollController scrollController = ScrollController();
  bool isScrollingDown = false;

  @override
  void initState() {
    if (mainStore.feedRoute) {
      mainStore.feedRoute = false;
    }
    handleScroll();
    super.initState();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          mainStore.setShowNav(false);
        }
      } else {
        mainStore.setShowNav(true);
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                EncontrarCuidadoNavBar(
                  leading: InkWell(
                    onDoubleTap: () {
                      store.fixSpec();
                    },
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: wXD(18, context),
                                right: wXD(11, context)),
                            child: Container()),
                        Text(
                          'Especialidades',
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: wXD(20, context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('specialties')
                        .orderBy('speciality', descending: false)
                        .get(),
                    builder: (context, snapshot) {
                      QuerySnapshot specials = snapshot.data;

                      if ((snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.hasError) ||
                          (snapshot == null || specials.docs == null) ||
                          !snapshot.hasData) {
                        return Expanded(
                            child: Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ));
                      }

                      List specialties = specials.docs.toList();

                      return Expanded(
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (details.delta.direction < 0) {
                              mainStore.setShowNav(false);
                            }
                            if (details.delta.direction > 0) {
                              mainStore.setShowNav(true);
                            }
                          },
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                Column(
                                  children: specialties.map((spec) {
                                    return SpecialtiesTile(
                                        text: spec.get('speciality'),
                                        onTap: () {
                                          Modular.to.pushNamed('/specialists',
                                              arguments: spec['id']);
                                        });
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: wXD(8, context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SpecialtiesTile extends StatelessWidget {
  final String text;
  final Function onTap;

  const SpecialtiesTile({
    Key key,
    this.text,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReportTile(
      onTap: onTap,
      iconColor: Color(0xff707070),
      top: 20,
      bottom: 20,
      fontSize: 16,
      text: '$text',
      fontWeight: FontWeight.w600,
    );
  }
}
