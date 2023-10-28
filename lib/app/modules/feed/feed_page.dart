import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/modules/root/root_store.dart';
import 'package:encontrarCuidado/app/modules/feed/feed_store.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/empty_state.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/person_photo.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'feed_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key key}) : super(key: key);
  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends ModularState<FeedPage, FeedStore> {
  final MainStore mainStore = Modular.get();
  final RootStore rootStore = Modular.get();
  ScrollController scrollController;
  bool feedTop = false;
  int allNotifications = 0;

  @override
  void initState() {
    scrollController = ScrollController();
    store.getHasNext();
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
        mainStore.setShowNav(false);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainStore.setShowNav(true);
      }

      if ((scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange)) {
        if (store.hasNext) {
          print('xxxxxxxxxxxxxxx scroll end xxxxxxxxxxxx');
          store.getMoreFeed(seconds: 1);
          // store.feedLimit += 10;
          // store.getLimit();
          // store.getHasNext();
        }
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
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;

    return Observer(builder: (_) {
      return PageStorage(
        bucket: rootStore.bucketGlobal,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                EncontrarCuidadoNavBar(
                  leading: Padding(
                    padding: EdgeInsets.fromLTRB(
                      wXD(15, context),
                      wXD(10, context),
                      wXD(10, context),
                      wXD(10, context),
                    ),
                    child: Image.asset(
                      'assets/img/grupo_43.png',
                      height: wXD(45, context),
                    ),
                  ),
                  action: store.authStore.user != null
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('patients')
                              .doc(store.authStore.user.uid)
                              .snapshots(),
                          builder: (context, snapshotUser) {
                            if (!snapshotUser.hasData) return Container();
                            if (snapshotUser.connectionState ==
                                ConnectionState.waiting)
                              return Center(
                                child: CircularProgressIndicator(),
                              );

                            if (snapshotUser.hasData) {
                              DocumentSnapshot userSnap = snapshotUser.data;
                              int newNotifications =
                                  userSnap['new_notifications'] != null
                                      ? userSnap['new_notifications']
                                      : 0;

                              int supportNotifications =
                                  userSnap['support_notifications'] != null
                                      ? userSnap['support_notifications']
                                      : 0;

                              allNotifications =
                                  newNotifications + supportNotifications;

                              return Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      Modular.to.pushNamed('/profile/');
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: wXD(10, context),
                                          top: wXD(7, context)),
                                      child: PersonPhoto(
                                        photo: userSnap['avatar'],
                                        borderColor: Color(0xff41C3B3),
                                        size: maxWidth * .11,
                                      ),
                                    ),
                                  ),
                                  allNotifications != 0
                                      ? Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            height: wXD(24, context),
                                            width: wXD(24, context),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xff21BCCE)),
                                            child: Center(
                                              child: Text(
                                                allNotifications <= 9
                                                    ? allNotifications
                                                        .toString()
                                                    : '+9',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            height: maxWidth * .0613,
                                            width: 23,
                                          ),
                                        ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          })
                      : Container(),
                ),
                store.authStore.user != null
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('patients')
                            .doc(store.authStore.user.uid)
                            .collection('feed')
                            .where('status', isEqualTo: 'VISIBLE')
                            .orderBy('created_at', descending: true)
                            .snapshots(),
                        builder: (context, snapshotFeed) {
                          if (snapshotFeed.hasData) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              store.getFeed(snapshotFeed.data);
                            });
                          }

                          return Container();
                        },
                      )
                    : Container(),
                Expanded(
                  child: Observer(
                    builder: (context) {
                      if (store.feedList == null) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        );
                      } else if (store.feedList.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            EmptyStateList(
                              image: 'assets/img/pacient_communication.png',
                              title: 'Sem postagens',
                              description:
                                  'Adicione uma localização ao seu perfil para começar a visualizar postagens',
                            ),
                          ],
                        );
                      } else {
                        return GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (details.delta.direction < 0) {
                              print('menor que zero');
                              mainStore.setShowNav(false);
                            }
                            if (details.delta.direction > 0) {
                              print('maior que zero');

                              mainStore.setShowNav(true);
                            }
                          },
                          child: RefreshIndicator(
                            onRefresh: () async {
                              store.addPosts = false;
                              setState(() {});
                              mainStore.setShowNav(true);
                            },
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: scrollController,
                              child: Column(
                                children: [
                                  ...List.generate(
                                    store.feedList.length,
                                    (index) {
                                      DocumentSnapshot feedDoc =
                                          store.feedList[index];
                                      print('feedDoc: $feedDoc');
                                      String since =
                                          store.getTime(feedDoc['created_at']);

                                      print(
                                          'xxxxxx feedId ${feedDoc['id']} xxxxxxxx');

                                      return FeedCard(
                                        doctorId: feedDoc['dr_id'],
                                        timeAgo: since,
                                        feedId: feedDoc['id'],
                                        imageUrl: feedDoc['bgr_image'],
                                        avatar: feedDoc['dr_avatar'],
                                        name: feedDoc['dr_name'],
                                        speciality: feedDoc['dr_speciality'],
                                        description: feedDoc['text'],
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: wXD(20, context),
                                  ),
                                  store.hasNext
                                      ? CircularProgressIndicator()
                                      : Container(),
                                  SizedBox(
                                    height: wXD(37, context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Observer(builder: (context) {
              return Visibility(
                visible: store.setCards,
                child: AnimatedContainer(
                  height: maxHeight,
                  width: maxWidth,
                  color:
                      !store.setCards ? Colors.transparent : Color(0x50000000),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(top: wXD(15, context)),
                      height: wXD(215, context),
                      width: wXD(324, context),
                      decoration: BoxDecoration(
                          color: Color(0xfffafafa),
                          borderRadius: BorderRadius.all(Radius.circular(33))),
                      child: Column(
                        children: [
                          Container(
                            width: wXD(240, context),
                            margin: EdgeInsets.only(top: wXD(15, context)),
                            child: Text(
                              '''Para realizar seu primeiro agendamento, é necessário adicionar um cartão em Perfil > Pagamentos > Adicionar Cartão. Deseja navegar para esta seção?''',
                              style: TextStyle(
                                fontSize: wXD(15, context),
                                fontWeight: FontWeight.w600,
                                color: Color(0xfa707070),
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          store.loadCircularDialogCard
                              ? Row(
                                  children: [
                                    Spacer(),
                                    CircularProgressIndicator(),
                                    Spacer(),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        store.setCardDialog(!store.setCards);
                                      },
                                      child: Container(
                                        height: wXD(47, context),
                                        width: wXD(98, context),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 3),
                                                  blurRadius: 3,
                                                  color: Color(0x28000000))
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(17)),
                                            border: Border.all(
                                                color: Color(0x80707070)),
                                            color: Color(0xfffafafa)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Não',
                                          style: TextStyle(
                                              color: Color(0xff2185D0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: wXD(16, context)),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () async {
                                        await store.setLoadCircular(true);
                                        store.setCardDialog(!store.setCards);
                                        Modular.to.pushNamed(
                                            '/payment/add-card',
                                            arguments: false);
                                      },
                                      child: Container(
                                        height: wXD(47, context),
                                        width: wXD(98, context),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 3),
                                                  blurRadius: 3,
                                                  color: Color(0x28000000))
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(17)),
                                            border: Border.all(
                                                color: Color(0x80707070)),
                                            color: Color(0xfffafafa)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sim',
                                          style: TextStyle(
                                              color: Color(0xff2185D0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: wXD(16, context)),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                          Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      )
          // )
          ;
    });
  }
}
