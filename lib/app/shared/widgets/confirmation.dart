import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import '../utilities.dart';
import 'card_profile.dart';

class Confirmation extends StatefulWidget {
  final bool routerReschedule;
  final bool routerConfirmAppoiment;
  final bool routerPayment;
  final String title;
  final String subTitle;
  final bool noAvatar;
  final Function callBack;
  const Confirmation({
    Key key,
    this.title,
    this.subTitle,
    this.noAvatar,
    this.routerReschedule = false,
    this.routerConfirmAppoiment = false,
    this.routerPayment = false,
    this.callBack,
  }) : super(key: key);
  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  final MainStore mainStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        if (widget.callBack != null) {
          widget.callBack();
        }
        if (widget.routerReschedule) {
          mainStore.setSelectedTrunk(2);
          // Modular.to
          //     .pushNamedAndRemoveUntil('/main', ModalRoute.withName('/main'));
          Modular.to.pushNamed('/main');
        }
        if (widget.routerConfirmAppoiment) {
          mainStore.setSelectedTrunk(2);
          if (mainStore.feedRoute) {
            mainStore.feedRoute = false;
            Modular.to.pop();
            Modular.to.pop();
            Modular.to.pop();
          } else {
            Modular.to.pop();
            Modular.to.pop();
            Modular.to.pop();
            Modular.to.pop();
          }
        }
        if (widget.routerPayment) {
          Modular.to.pop();
          Modular.to.pop();
          Modular.to.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: wXD(10, context),
                  left: wXD(17, context),
                  right: wXD(7, context),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/img/logo-icone.png',
                      height: wXD(47, context),
                    ),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (widget.callBack != null) {
                          widget.callBack();
                        }
                        if (widget.routerReschedule) {
                          mainStore.setSelectedTrunk(2);
                          // Modular.to.pushNamedAndRemoveUntil(
                          //     '/main', ModalRoute.withName('/main'));
                          if (widget.callBack != null) {
                            widget.callBack();
                          }
                          Modular.to.pushNamed('/main');
                        }
                        if (widget.routerConfirmAppoiment) {
                          mainStore.setSelectedTrunk(2);
                          if (mainStore.feedRoute) {
                            mainStore.feedRoute = false;
                            Modular.to.pop();
                            Modular.to.pop();
                            Modular.to.pop();
                          } else {
                            Modular.to.pop();
                            Modular.to.pop();
                            Modular.to.pop();
                            Modular.to.pop();
                          }
                        }
                        if (widget.routerPayment) {
                          Modular.to.pop();
                          Modular.to.pop();
                          Modular.to.pop();
                        }
                      },
                      child: Icon(
                        Icons.close,
                        size: wXD(33, context),
                        color: Color(0xff707070),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              widget.noAvatar == true
                  ? Container()
                  : Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: wXD(3, context)),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('patients')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CardProfile(size: wXD(53, context));
                                } else {
                                  return CardProfile(
                                    size: wXD(53, context),
                                    photo: snapshot.data['avatar'],
                                  );
                                }
                              }),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: wXD(36, context),
                            width: wXD(36, context),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white, width: wXD(3, context)),
                              borderRadius: BorderRadius.circular(90),
                              color: Color(0xff41C3B3),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Color(0xfffafafa),
                              size: wXD(22, context),
                            ),
                          ),
                        ),
                      ],
                    ),
              Spacer(),
              Container(
                width: maxWidth,
                padding: EdgeInsets.symmetric(horizontal: wXD(25, context)),
                child: Text(
                  '${widget.title}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: maxWidth,
                padding: EdgeInsets.symmetric(horizontal: wXD(25, context)),
                child: Text(
                  '${widget.subTitle}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  children: [
                    Container(
                      height: wXD(321, context),
                      width: wXD(494, context),
                      // margin: EdgeInsets.only(right: wXD(100, context)),
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        "./assets/svg/personcalendar.svg",
                        semanticsLabel: 'Acme Logo',
                        height: wXD(321, context),
                        width: wXD(494, context),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    // SizedBox(width: wXD(50, context))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmRefund extends StatefulWidget {
  final bool routerReschedule;
  final bool routerConfirmAppoiment;
  final bool routerPayment;
  final String title;
  final String subTitle;
  final bool noAvatar;
  const ConfirmRefund({
    Key key,
    this.title,
    this.subTitle,
    this.noAvatar,
    this.routerReschedule = false,
    this.routerConfirmAppoiment = false,
    this.routerPayment = false,
  }) : super(key: key);
  @override
  _ConfirmRefundState createState() => _ConfirmRefundState();
}

class _ConfirmRefundState extends State<ConfirmRefund> {
  final MainStore mainStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        if (widget.routerReschedule) {
          mainStore.setSelectedTrunk(2);
          Modular.to
              .pushNamedAndRemoveUntil('/main', ModalRoute.withName('/main'));
          // Modular.to.pushNamed('/scheduling');
        }
        if (widget.routerConfirmAppoiment) {
          mainStore.setSelectedTrunk(2);
          if (mainStore.feedRoute) {
            mainStore.feedRoute = false;
            Modular.to.pop();
            Modular.to.pop();
            Modular.to.pop();
          } else {
            Modular.to.pop();
            Modular.to.pop();
            Modular.to.pop();
            Modular.to.pop();
          }
        }
        if (widget.routerPayment) {
          Modular.to.pop();
          Modular.to.pop();
          Modular.to.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: wXD(10, context),
                  left: wXD(17, context),
                  right: wXD(7, context),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/img/logo-icone.png',
                      height: wXD(47, context),
                    ),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (widget.routerReschedule) {
                          mainStore.setSelectedTrunk(2);
                          Modular.to.pushNamedAndRemoveUntil(
                              '/main', ModalRoute.withName('/main'));
                          // Modular.to.pushNamed('/scheduling');
                        }
                        if (widget.routerConfirmAppoiment) {
                          mainStore.setSelectedTrunk(2);
                          if (mainStore.feedRoute) {
                            mainStore.feedRoute = false;
                            Modular.to.pop();
                            Modular.to.pop();
                            Modular.to.pop();
                          } else {
                            Modular.to.pop();
                            Modular.to.pop();
                            Modular.to.pop();
                            Modular.to.pop();
                          }
                        }
                        if (widget.routerPayment) {
                          Modular.to.pop();
                          Modular.to.pop();
                          Modular.to.pop();
                        }
                      },
                      child: Icon(
                        Icons.close,
                        size: wXD(33, context),
                        color: Color(0xff707070),
                      ),
                    ),
                  ],
                ),
              ),
              // Spacer(),
              // widget.noAvatar == true
              //     ? Container()
              //     : Stack(
              //         children: [
              //           Padding(
              //             padding: EdgeInsets.only(bottom: wXD(3, context)),
              //             child: StreamBuilder(
              //                 stream: FirebaseFirestore.instance
              //                     .collection('patients')
              //                     .doc(FirebaseAuth.instance.currentUser.uid)
              //                     .snapshots(),
              //                 builder: (context, snapshot) {
              //                   if (!snapshot.hasData) {
              //                     return CardProfile(size: wXD(53, context));
              //                   } else {
              //                     return CardProfile(
              //                       size: wXD(53, context),
              //                       photo: snapshot.data['avatar'],
              //                     );
              //                   }
              //                 }),
              //           ),
              //           Positioned(
              //             bottom: 0,
              //             right: 0,
              //             child: Container(
              //               height: wXD(36, context),
              //               width: wXD(36, context),
              //               decoration: BoxDecoration(
              //                 border: Border.all(
              //                     color: Colors.white, width: wXD(3, context)),
              //                 borderRadius: BorderRadius.circular(90),
              //                 color: Color(0xff41C3B3),
              //               ),
              //               child: Icon(
              //                 Icons.check,
              //                 color: Color(0xfffafafa),
              //                 size: wXD(22, context),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              Spacer(),
              Container(
                width: maxWidth,
                padding: EdgeInsets.symmetric(horizontal: wXD(25, context)),
                alignment: Alignment.center,
                child: Text(
                  '${widget.title}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: maxWidth,
                padding: EdgeInsets.symmetric(horizontal: wXD(25, context)),
                alignment: Alignment.center,
                child: Text(
                  '${widget.subTitle}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: Container(
                  alignment: Alignment.topRight,
                  height: wXD(318, context),
                  child: SvgPicture.asset(
                    "./assets/svg/personmoney.svg",
                    semanticsLabel: 'Acme Logo',
                    height: wXD(497, context),
                    width: wXD(358, context),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
