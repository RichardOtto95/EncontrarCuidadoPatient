import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/messages/widgets/empty_state.dart';
import 'package:encontrarCuidado/app/modules/search/widgets/sugestion.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import 'search_store.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final SearchStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  ScrollController scrollController = ScrollController();
  bool isScrollingDown = false;
  FocusNode medicFocus;
  FocusNode cepFocus;
  var queryResultSet = [];
  var tempSearchStore = [];
  bool emptyDocs = false;
  bool hasFocus = false;

  @override
  void initState() {
    medicFocus = FocusNode();
    cepFocus = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.getLocation('');
    });
    handleScroll();
    focusListener();
    if (mainStore.feedRoute) {
      mainStore.feedRoute = false;
    }
    super.initState();
  }

  void focusListener() {
    medicFocus.addListener(() {
      if (medicFocus.hasFocus) {
        hasFocus = true;
        mainStore.setShowNav(false);
      } else {
        hasFocus = false;
        mainStore.setShowNav(true);
      }
    });
    cepFocus.addListener(() {
      if (cepFocus.hasFocus) {
        hasFocus = true;
        mainStore.setShowNav(false);
      } else {
        hasFocus = false;
        mainStore.setShowNav(true);
      }
    });
  }

  void handleScroll() async {
    scrollController.addListener(() {
      // print('hasFocus: $hasFocus');
      // print('offSet: ${scrollController.offset}');
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          mainStore.setShowNav(false);
        }
      } else if (!hasFocus) {
        mainStore.setShowNav(true);
      }
    });
  }

  @override
  void dispose() {
    medicFocus.dispose();
    cepFocus.dispose();
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double maxWidth = MediaQuery.of(context).size.width;
    return Listener(
      onPointerDown: (a) {
        medicFocus.unfocus();
        cepFocus.unfocus();
      },
      onPointerMove: (event) {
        // print('scrollBool: ${scrollController.position.activity.isScrolling}');
        if (scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          // print(
          // 'scrollDirection: ${scrollController.position.userScrollDirection}');

          mainStore.setShowNav(false);
        } else {
          mainStore.setShowNav(true);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: StatefulBuilder(builder: (context, stateset) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Observer(
                  builder: (context) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EncontrarCuidadoNavBar(
                            leading: Row(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: wXD(18, context),
                                        right: wXD(11, context)),
                                    child: Container()),
                                Text(
                                  'Pesquisar',
                                  style: TextStyle(
                                    color: Color(0xff707070),
                                    fontSize: wXD(20, context),
                                  ),
                                ),
                                // ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                wXD(26, context),
                                wXD(13, context),
                                wXD(26, context),
                                wXD(0, context),
                              ),
                              height: wXD(58, context),
                              width: wXD(320, context),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                border: Border.all(
                                  color: cepFocus.hasFocus
                                      ? Color(0xff2185D0)
                                      : Color(0xff707070),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Container(
                                    width: wXD(245, context),
                                    child: TextFormField(
                                      textCapitalization:
                                          TextCapitalization.words,
                                      controller: store.locController,
                                      enableSuggestions: true,
                                      onTap: () {
                                        mainStore.setShowNav(false);
                                      },
                                      onChanged: (value) {
                                        store.stateOrCity = null;
                                        store
                                            .setLength(value.characters.length);
                                        store.localSearch(
                                            value, value.characters.length);
                                      },
                                      focusNode: cepFocus,
                                      cursorColor: Color(0xff707070),
                                      decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.location_on,
                                            color: cepFocus.hasFocus
                                                ? Color(0xff2185D0)
                                                : Color(0xff707070)
                                                    .withOpacity(.6),
                                            size: wXD(25, context),
                                          ),
                                        ),
                                        border: InputBorder.none,
                                        hintText:
                                            'Encontre por bairro, cidade ou CEP',
                                        hintStyle: TextStyle(
                                          fontSize: wXD(14, context),
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color(0xff7C8085).withOpacity(.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      store.stateOrCity = null;
                                      store.substr1.clear();
                                      store.resetLocal();
                                      store.locController.clear();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: cepFocus.hasFocus
                                          ? Color(0xff2185D0)
                                          : Color(0xff707070).withOpacity(.6),
                                      size: wXD(25, context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                wXD(26, context),
                                wXD(13, context),
                                wXD(26, context),
                                wXD(0, context),
                              ),
                              height: wXD(58, context),
                              width: wXD(320, context),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                border: Border.all(
                                  color: medicFocus.hasFocus
                                      ? Color(0xff2185D0)
                                      : Color(0xff707070),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Container(
                                    width: wXD(245, context),
                                    child: TextFormField(
                                      textCapitalization:
                                          TextCapitalization.words,
                                      controller: store.spcController,
                                      enableSuggestions: true,
                                      onTap: () {
                                        mainStore.setShowNav(false);
                                      },
                                      onChanged: (value) {
                                        store.setSpecialty(null);
                                        store.specialSearch(
                                            value, value.characters.length);
                                      },
                                      focusNode: medicFocus,
                                      cursorColor: Color(0xff707070),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: medicFocus.hasFocus
                                              ? Color(0xff2185D0)
                                              : Color(0xff707070),
                                          size: wXD(25, context),
                                        ),
                                        border: InputBorder.none,
                                        hintText: store.speciality == null
                                            ? 'Encontre especialistas'
                                            : store.speciality,
                                        hintStyle: TextStyle(
                                          fontSize: wXD(14, context),
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color(0xff7C8085).withOpacity(.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      store.setSpecialty(null);
                                      store.setSpecialtyID(null);
                                      store.spcController.clear();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: medicFocus.hasFocus
                                          ? Color(0xff2185D0)
                                          : Color(0xff707070).withOpacity(.6),
                                      size: wXD(25, context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TitleWidget(
                            title: 'Sugestões',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: wXD(16, context),
                                fontWeight: FontWeight.w600),
                            left: wXD(24, context),
                            top: wXD(15, context),
                            bottom: wXD(15, context),
                          ),
                          StreamBuilder(
                            stream: (store.substr1.isEmpty &&
                                    store.specialityID == null)
                                ? FirebaseFirestore.instance
                                    .collection('doctors')
                                    .where('country', isEqualTo: 'Brasil')
                                    .where('premium', isEqualTo: true)
                                    .where('status', isEqualTo: 'ACTIVE')
                                    .orderBy('state', descending: false)
                                    .limit(100)
                                    .snapshots()
                                : (store.substr1.isNotEmpty &&
                                        store.specialityID == null)
                                    ? FirebaseFirestore.instance
                                        .collection('doctors')
                                        .where('address_keys',
                                            arrayContainsAny: store.substr1)
                                        .where('premium', isEqualTo: true)
                                        .where('status', isEqualTo: 'ACTIVE')
                                        .orderBy('state', descending: false)
                                        .snapshots()
                                    : (store.substr1.isEmpty &&
                                            store.specialityID != null)
                                        ? FirebaseFirestore.instance
                                            .collection('doctors')
                                            .where('speciality',
                                                isEqualTo: store.specialityID)
                                            .where('premium', isEqualTo: true)
                                            .where('status',
                                                isEqualTo: 'ACTIVE')
                                            .orderBy('state', descending: false)
                                            .snapshots()
                                        : (store.substr1.isNotEmpty &&
                                                store.specialityID != null)
                                            ? FirebaseFirestore.instance
                                                .collection('doctors')
                                                .where('address_keys',
                                                    arrayContainsAny:
                                                        store.substr1)
                                                .where('speciality',
                                                    isEqualTo:
                                                        store.specialityID)
                                                .where('premium',
                                                    isEqualTo: true)
                                                .where('status',
                                                    isEqualTo: 'ACTIVE')
                                                .orderBy('state',
                                                    descending: false)
                                                .snapshots()
                                            : FirebaseFirestore.instance
                                                .collection('doctors')
                                                .where('premium',
                                                    isEqualTo: true)
                                                .where('status',
                                                    isEqualTo: 'ACTIVE')
                                                .orderBy('state',
                                                    descending: false)
                                                .limit(100)
                                                .snapshots(),
                            builder: (context, snapshot) {
                              QuerySnapshot drsSnap = snapshot.data;

                              if (!snapshot.hasData) {
                                return Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .3,
                                        ),
                                        Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              List<DocumentSnapshot> drsList = [];
                              drsSnap.docs.forEach((doctor) {
                                if (doctor['type'] == 'DOCTOR') {
                                  drsList.add(doctor);
                                }
                              });

                              if (drsList.isEmpty) {
                                emptyDocs = true;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (emptyDocs) {
                                    if (store.firstLook == true) {
                                      store.stateOrCity = null;
                                      store.substr1.clear();
                                      store.specialityID = null;
                                      store.firstLook = false;
                                    }
                                  }
                                });
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
                                      child: Column(
                                        children: [
                                          EmptyStateList(
                                            image: 'assets/img/meditation.png',
                                            title:
                                                'Sem especialistas cadastrados',
                                            description:
                                                'Não foram encontrados especialistas com estas especificações',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

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
                                        children: drsList.map((dr) {
                                      // if (dr['type'] == 'doctor') {
                                      if (store.substr1.isNotEmpty &&
                                          dr['state'] != null &&
                                          dr['city'] != null &&
                                          dr['neighborhood'] != null &&
                                          dr['speciality'] != null) {
                                        store.address(dr['state'], dr['city'],
                                            dr['neighborhood']);
                                      }
                                      return Suggestion(
                                          mainStore: mainStore,
                                          drName: dr['username'],
                                          drId: dr['id'],
                                          state: dr['state'],
                                          speciality: dr['speciality_name'],
                                          location: dr['city']);
                                    }).toList()),
                                  ),
                                ),
                              );
                            },
                          )
                        ]);
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
