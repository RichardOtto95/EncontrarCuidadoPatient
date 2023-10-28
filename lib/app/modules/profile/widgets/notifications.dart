import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/notification_model.dart';
import 'package:encontrarCuidado/app/core/models/time_model.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:encontrarCuidado/app/modules/messages/widgets/empty_state.dart';
import 'package:encontrarCuidado/app/modules/profile/profile_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  const Notifications({
    Key key,
  }) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final ProfileStore store = Modular.get();
  final AuthStore authStore = Modular.get();

  bool emptyState = false;

  @override
  Widget build(BuildContext context) {
    print('zzzzzzzzzzzzzzzzzz notifications');
    return WillPopScope(
      onWillPop: () async {
        store.backNotifications();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                EncontrarCuidadoAppBar(
                  title: 'Notificações',
                  onTap: () async {
                    store.backNotifications();
                    Modular.to.pop();
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('patients')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection('notifications')
                      .where('status', isEqualTo: 'SENDED')
                      .orderBy('dispatched_at', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: wXD(50, context)),
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      QuerySnapshot _qs = snapshot.data;
                      if (_qs.docs.isEmpty) {
                        return EmptyStateList(
                          image: 'assets/img/work_on2.png',
                          description: 'Sem notificações para serem listadas',
                        );
                      } else {
                        List<NotificationModel> notVisualized = [];
                        List<NotificationModel> visualized = [];
                        _qs.docs.forEach((notification) {
                          print(
                              '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% notification id ${notification.id}');
                          NotificationModel _notification =
                              NotificationModel.fromDocument(notification);
                          if (notification['viewed']) {
                            visualized.add(_notification);
                          } else {
                            notVisualized.add(_notification);
                          }
                        });

                        print('notVisualized: ${notVisualized.length}');
                        print('visualized: ${visualized.length}');

                        bool hasNewNotifications = notVisualized.length != 0;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            hasNewNotifications
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      wXD(21, context),
                                      wXD(7, context),
                                      0,
                                      wXD(10, context),
                                    ),
                                    child: Text(
                                      'Novas',
                                      style: TextStyle(
                                        color: Color(0xff4C4C4C),
                                        fontSize: wXD(20, context),
                                      ),
                                    ),
                                  )
                                : Container(),
                            ...List.generate(notVisualized.length, (index) {
                              print(
                                  'xxxxxx  sender Id ${notVisualized[index].senderId} xxxxxxxxxx');
                              return Notification(
                                senderId: notVisualized[index].senderId,
                                text: notVisualized[index].text,
                                date:
                                    notVisualized[index].dispatchedAt.toDate(),
                              );
                            }),
                            visualized.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      wXD(21, context),
                                      wXD(7, context),
                                      0,
                                      wXD(10, context),
                                    ),
                                    child: Text(
                                      'Anteriores',
                                      style: TextStyle(
                                        color: Color(0xff4C4C4C),
                                        fontSize: wXD(20, context),
                                      ),
                                    ),
                                  )
                                : Container(),
                            ...List.generate(visualized.length, (index) {
                              print(
                                  'xxxxxx  sender Id ${visualized[index].senderId} xxxxxxxxxx');
                              return Notification(
                                senderId: visualized[index].senderId,
                                text: visualized[index].text,
                                viewed: true,
                                date: visualized[index].dispatchedAt.toDate(),
                              );
                            }),
                          ],
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Notification extends StatelessWidget {
  final bool viewed;
  final String text;
  final String message;
  final String title;
  final String senderId;
  final DateTime date;

  const Notification({
    Key key,
    this.viewed = false,
    this.text,
    this.title = '',
    this.message = '',
    this.date,
    this.senderId,
  }) : super(key: key);

  String getDate() {
    DateTime now = DateTime.now();
    Duration dur;
    dur = now.difference(date);
    String day = dur.inDays == 0
        ? 'Hoje'
        : dur.inDays == 1
            ? 'Ontem'
            : DateFormat("EEEE", "pt_BR").format(date);

    return day + ', ${TimeModel().hour(Timestamp.fromDate(date))}';
  }

  @override
  Widget build(BuildContext context) {
    String avatar;

    return InkWell(
      onTap: () {},
      child: Container(
        height: wXD(85, context),
        decoration: BoxDecoration(
          color: viewed ? Colors.transparent : Color(0x3541C3B3),
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                wXD(15, context),
                wXD(0, context),
                wXD(13, context),
                wXD(0, context),
              ),
              child: senderId != null
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(senderId)
                          .snapshots(),
                      builder: (context, snapshotDoctor) {
                        if (snapshotDoctor.hasData) {
                          DocumentSnapshot doctorDoc = snapshotDoctor.data;
                          avatar = doctorDoc['avatar'];
                        }
                        return CircleAvatar(
                          backgroundImage: avatar == null
                              ? AssetImage('assets/img/defaultUser.png')
                              : NetworkImage(avatar),
                          radius: wXD(32, context),
                        );
                      })
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('info')
                          .snapshots(),
                      builder: (context, snapshotInfo) {
                        if (snapshotInfo.hasData) {
                          QuerySnapshot qs = snapshotInfo.data;
                          DocumentSnapshot infoDoc = qs.docs.first;
                          avatar = infoDoc['support_avatar'];
                        }
                        return CircleAvatar(
                          backgroundImage: avatar == null
                              ? AssetImage('assets/img/defaultUser.png')
                              : NetworkImage(avatar),
                          radius: wXD(32, context),
                        );
                      },
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title == ''
                    ? Container()
                    : Container(
                        width: maxWidth(context) * .74,
                        child: Text(
                          '$title',
                          strutStyle: StrutStyle(),
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff707070),
                          ),
                        ),
                      ),
                Container(
                  width: maxWidth(context) * .74,
                  child: Text(
                    '$text',
                    strutStyle: StrutStyle(),
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff707070),
                    ),
                  ),
                ),
                Text(
                  getDate(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0x72707070),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
