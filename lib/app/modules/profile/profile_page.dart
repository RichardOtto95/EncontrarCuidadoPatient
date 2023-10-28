import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/profile/widgets/confirm_profile_edit.dart';
import 'package:encontrarCuidado/app/modules/profile/widgets/profile_till.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/card_profile.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:encontrarCuidado/app/modules/profile/profile_store.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String title;
  const ProfilePage({Key key, this.title = 'ProfilePage'}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final ProfileStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final AuthStore authStore = Modular.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String newNotification = '', supportNotifications = '';

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Modular.to.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: store.authStore.user != null
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('patients')
                      .doc(store.authStore.user.uid)
                      .snapshots(),
                  builder: (context, snapshotUser) {
                    if (!snapshotUser.hasData) {
                      return Container();
                    }
                    if (snapshotUser.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    DocumentSnapshot userSnap = snapshotUser.data;
                    if (userSnap['new_notifications'] != null &&
                        userSnap['new_notifications'] != 0) {
                      newNotification = userSnap['new_notifications'] <= 9
                          ? userSnap['new_notifications'].toString()
                          : '+9';
                    } else {
                      newNotification = '';
                    }

                    if (userSnap['support_notifications'] != null &&
                        userSnap['support_notifications'] != 0) {
                      supportNotifications =
                          userSnap['support_notifications'] <= 9
                              ? userSnap['support_notifications'].toString()
                              : '+9';
                    } else {
                      supportNotifications = '';
                    }

                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: maxHeight(context),
                          width: maxWidth(context),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.only(
                              top: wXD(20, context),
                              left: wXD(19, context),
                            ),
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Modular.to.pop();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    size: wXD(25, context),
                                    color: Color(0xffFAFAFA),
                                  ),
                                  SizedBox(width: wXD(7, context)),
                                  Text(
                                    'Perfil',
                                    style: TextStyle(
                                      color: Color(0xffFAFAFA),
                                      fontSize: maxWidth(context) * .05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height: maxHeight(context) * .3,
                            width: maxWidth(context),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                  color: Color(0x30000000),
                                )
                              ],
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff41C3B3),
                                  Color(0xff21BCCE),
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: wXD(60, context),
                          child: Container(
                            width: maxWidth(context) * .9,
                            decoration: BoxDecoration(
                              color: Color(0xffFAFAFA),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: wXD(50, context),
                                ),
                                InkWell(
                                  onTap: () {
                                    PatientModel patientModel =
                                        PatientModel.fromDocument(userSnap);
                                    Modular.to.pushNamed(
                                        '/profile/edit-profile',
                                        arguments: patientModel);
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: wXD(35, context),
                                          horizontal: wXD(35, context),
                                        ),
                                        child: Text(
                                          userSnap['username'],
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Color(0xff707070),
                                            fontSize: wXD(25, context),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: wXD(0, context),
                                        right: wXD(0, context),
                                        child: Icon(
                                          Icons.create,
                                          size: 25,
                                          color: Color(0xff707070),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ProfileTill(
                                  onTap: () => Modular.to
                                      .pushNamed('/profile/notifications'),
                                  title: 'Notificações',
                                  icon: Icons.notifications_none,
                                  index: newNotification,
                                ),
                                ProfileTill(
                                  onTap: () => Modular.to.pushNamed('/payment'),
                                  title: 'Pagamentos',
                                  icon: Icons.payment_outlined,
                                ),
                                ProfileTill(
                                  onTap: () {
                                    Modular.to.pushNamed('/dependents');
                                  },
                                  title: 'Meus Dependentes',
                                  icon: Icons.people_rounded,
                                ),
                                ProfileTill(
                                  onTap: () async {
                                    // if (mainStore.hasSupport) {
                                    //   print(
                                    //       'mainStore.supportId ${mainStore.supportId}');
                                    //   store.getSuportChat(mainStore.supportId);
                                    // }

                                    // if (!mainStore.clickSupport) {
                                    // mainStore.clickSupport = true;
                                    mainStore.setSupportChat();
                                    Modular.to.pushNamed('/suport');
                                    // }
                                  },
                                  title: 'Suporte',
                                  icon: Icons.headset_mic_rounded,
                                  index: supportNotifications,
                                ),
                                ProfileTill(
                                  onTap: () {
                                    Modular.to.pushNamed('/configurations');
                                  },
                                  title: 'Configurações',
                                  icon: Icons.settings,
                                ),
                                ProfileTill(
                                  bottomBorder: false,
                                  onTap: () {
                                    store.logout = true;
                                  },
                                  title: 'Sair',
                                  icon: Icons.logout,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: wXD(34, context),
                          child: InkWell(
                            onTap: () {
                              PatientModel patientModel =
                                  PatientModel.fromDocument(userSnap);
                              Modular.to.pushNamed('/profile/edit-profile',
                                  arguments: patientModel);
                            },
                            child: CardProfile(
                              size: wXD(47, context),
                              photo: userSnap['avatar'],
                            ),
                          ),
                        ),
                        Observer(builder: (context) {
                          bool loadCircular = false;
                          return Visibility(
                            visible: store.logout,
                            child: InkWell(
                              onTap: () {
                                store.logout = false;
                              },
                              child: Container(
                                height: maxHeight(context),
                                width: maxWidth(context),
                                color: !store.logout
                                    ? Colors.transparent
                                    : Color(0x50000000),
                                child: Center(
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(top: wXD(5, context)),
                                    height: wXD(160, context),
                                    width: wXD(324, context),
                                    decoration: BoxDecoration(
                                        color: Color(0xfffafafa),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(38))),
                                    child: StatefulBuilder(
                                        builder: (context, stateSet) {
                                      return Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Tem certeza que deseja sair?',
                                            style: TextStyle(
                                              fontSize: wXD(15, context),
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xfa707070),
                                            ),
                                          ),
                                          Spacer(),
                                          loadCircular
                                              ? Row(
                                                  children: [
                                                    Spacer(),
                                                    CircularProgressIndicator(),
                                                    Spacer()
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Spacer(),
                                                    InkWell(
                                                      onTap: () {
                                                        store.logout = false;
                                                      },
                                                      child: Container(
                                                        height:
                                                            wXD(47, context),
                                                        width: wXD(98, context),
                                                        decoration: BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          0, 3),
                                                                  blurRadius: 3,
                                                                  color: Color(
                                                                      0x28000000))
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            22)),
                                                            border: Border.all(
                                                                color: Color(
                                                                    0x80707070)),
                                                            color: Color(
                                                                0xfffafafa)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Não',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff2185D0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: wXD(
                                                                  16, context)),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    InkWell(
                                                      onTap: () async {
                                                        stateSet(() {
                                                          loadCircular = true;
                                                        });
                                                        await store
                                                            .setTokenLogout();
                                                        await mainStore
                                                            .userConnected(
                                                                false);
                                                        store.logout = false;
                                                        mainStore.supportId =
                                                            null;
                                                        authStore.signout();

                                                        Modular.to
                                                            .pushNamed('/sign');
                                                      },
                                                      child: Container(
                                                        height:
                                                            wXD(47, context),
                                                        width: wXD(98, context),
                                                        decoration: BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          0, 3),
                                                                  blurRadius: 3,
                                                                  color: Color(
                                                                      0x28000000))
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            22)),
                                                            border: Border.all(
                                                                color: Color(
                                                                    0x80707070)),
                                                            color: Color(
                                                                0xfffafafa)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Sim',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff2185D0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: wXD(
                                                                  16, context)),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                          Spacer(),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    );
                  })
              : Container(),
        ),
      ),
    );
  }
}
