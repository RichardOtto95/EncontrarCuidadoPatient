import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/modules/root/root_store.dart';
import 'package:encontrarCuidado/app/modules/feed/feed_module.dart';
import 'package:encontrarCuidado/app/modules/main/widgets/set_cards.dart';
import 'package:encontrarCuidado/app/modules/messages/messages_module.dart';
import 'package:encontrarCuidado/app/modules/schedulings/scheduling_module.dart';
import 'package:encontrarCuidado/app/modules/search/search_module.dart';
import 'package:encontrarCuidado/app/modules/specialty/specialty_module.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
// import 'package:encontrarCuidado/app/shared/widgets/fit_requested_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';
import 'widgets/evaluate_service.dart';
import 'widgets/popup_reschedule.dart';

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({Key key, this.title = 'MainPage'}) : super(key: key);
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with WidgetsBindingObserver {
  final MainStore mainStore = Modular.get();
  bool homePage = false;
  bool specialtiePage = false;
  bool messagePage = false;
  bool searchPage = false;
  bool _isInForeground = true;
  RootStore rootStore = Modular.get();
  MainStore store = Modular.get();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.getPopUps(context);
    });

    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
    WidgetsBinding.instance.addObserver(this);
    store.userConnected(true);
    store.getUser();
    store.setInfo();
    store.nullSpec();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;

      BotToast.showSimpleNotification(
        title: '${notification.title}',
        subTitle: '${notification.body}',
        borderRadius: 25,
        backgroundColor: Color(0xff21BCCE),
        subTitleStyle: TextStyle(
          color: Colors.white,
        ),
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        // subtitle:'' ,
        duration: Duration(seconds: 7),
      );
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    store.userConnected(_isInForeground);
    switch (state) {
      case AppLifecycleState.resumed:
        // Modular.to.pushNamed('/');
        print("%%%%%%%%%%%%% app in resumed %%%%%%%%%%%%%");
        break;
      case AppLifecycleState.inactive:
        print("%%%%%%%%%%%%% app in inactive %%%%%%%%%%%%%");
        break;
      case AppLifecycleState.paused:
        print("%%%%%%%%%%%%% app in paused %%%%%%%%%%%%%");
        break;
      case AppLifecycleState.detached:
        print("%%%%%%%%%%%%% app in detached %%%%%%%%%%%%%");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Widget> trunkModule = [
    FeedModule(),
    SpecialtyModule(),
    SchedulingModule(),
    MessagesModule(),
    SearchModule()
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Observer(builder: (_) {
        // print('xxxxxxxxxxxx Observer ${store.authStore.user.uid} xxxxxxxxxxx');
        return Scaffold(
          backgroundColor: Color(0xfffafafa),
          body: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: maxHeight(context),
                  width: maxWidth(context),
                  child: Observer(builder: (_) {
                    return trunkModule[mainStore.selectedTrunk];
                  }),
                ),
                AnimatedPositioned(
                  duration: Duration(seconds: 1),
                  curve: Curves.ease,
                  bottom: !store.showNavigator ? wXD(-66, context) : 0,
                  child: Container(
                    // duration: Duration(seconds: 1),
                    // curve: Curves.decelerate,
                    height: wXD(66, context),
                    width: maxWidth(context),
                    decoration: BoxDecoration(
                      color: Color(0xfffafafa),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset.zero,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EncontrarCuidadoTile(
                          ontap: () {
                            if (store.selectedTrunk != 0) {
                              store.setSelectedTrunk(0);
                            }
                          },
                          show: true,
                          icon: Icons.home_outlined,
                          title: 'Início',
                          thisPage: store.selectedTrunk == 0,
                        ),
                        EncontrarCuidadoTile(
                          ontap: () {
                            if (store.selectedTrunk != 1) {
                              store.setSelectedTrunk(1);
                            }
                          },
                          show: true,
                          icon: Icons.medical_services_outlined,
                          title: 'Especialidades',
                          thisPage: store.selectedTrunk == 1,
                        ),
                        Spacer(),
                        EncontrarCuidadoTile(
                          ontap: () async {
                            if (store.selectedTrunk != 3) {
                              // await store.initialChat();
                              store.setSelectedTrunk(3);
                            }
                          },
                          show: true,
                          icon: Icons.messenger_outline,
                          title: 'Mensagens',
                          thisPage: store.selectedTrunk == 3,
                        ),
                        EncontrarCuidadoTile(
                          ontap: () {
                            if (store.selectedTrunk != 4) {
                              store.setSelectedTrunk(4);
                            }
                          },
                          show: true,
                          icon: Icons.search,
                          title: 'Pesquisar',
                          thisPage: store.selectedTrunk == 4,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: maxWidth(context) * 30 / 375,
                  child: InkWell(
                    onTap: () {
                      if (store.selectedTrunk != 2) {
                        // setState(() {
                        store.setSelectedTrunk(2);
                        // });
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.decelerate,
                      height: store.showNavigator
                          ? maxWidth(context) * 70 / 375
                          : 0,
                      width: store.showNavigator
                          ? maxWidth(context) * 70 / 375
                          : 0,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            offset: Offset(0, 3),
                            color: Color(0x30000000),
                          ),
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff41C3B3),
                              Color(0xff21BCCE),
                            ]),
                        borderRadius: BorderRadius.circular(90),
                        border: Border.all(
                          width: 3,
                          color: store.selectedTrunk == 2
                              ? Color(0xff2185D0)
                              : Color(0xfffafafa),
                        ),
                      ),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xfffafafa),
                        size: store.showNavigator ? maxWidth(context) * .08 : 0,
                      ),
                    ),
                  ),
                ),
                // Observer(builder: (context) {
                //   return ObservationDialog(
                //     mainStore: mainStore,
                //     text: store.textFit,
                //     question: 'Você pretende aceitar este agendamento?',
                //     visible: store.popUpFitRequest,
                //     onCancel: () {
                //       store.answerFit(false);
                //     },
                //     onConfirm: () {
                //       store.answerFit(true);
                //     },
                //   );
                // }),
                Observer(builder: (context) {
                  return EvaluateService(
                    visible: store.popUpRating,
                  );
                }),
                Observer(builder: (context) {
                  return PopUpReschedule(
                    visible: store.popUpRescheduleRequest,
                    mainStore: mainStore,
                    text: mainStore.textPopUpReschedule,
                    question: 'Você deseja reagendar essa consulta?',
                    onCancel: () async {
                      await store.rescheduleRefused();
                    },
                    onConfirm: () async {
                      await store.rescheduleAccept();
                    },
                  );
                }),
                SetCards(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance.collection('patients').doc(userId).update({
      'token_id': FieldValue.arrayUnion([token]),
    });
  }
}
