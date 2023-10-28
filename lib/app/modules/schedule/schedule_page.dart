import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/doctor_model.dart';
import 'package:encontrarCuidado/app/core/models/schedule_model.dart';
import 'package:encontrarCuidado/app/core/models/time_model.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/schedule/schedule_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/empty_state.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrarCuidado/app/shared/widgets/hour_periods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

class SchedulePage extends StatefulWidget {
  final ModularArguments group;

  SchedulePage({
    Key key,
    this.group,
  }) : super(key: key);
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScheduleStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  int type = 1;
  // String _doctorId;
  bool drRoute;
  @override
  void initState() {
    drRoute = widget.group.data;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialDates();
    });

    super.initState();
  }

  initialDates() {
    if (mainStore.returning) {
      store.setVisibleDates(mainStore.appointmentReturn.date.toDate());
    } else {
      store.setVisibleDates(DateTime.now().subtract(Duration(hours: 3)));
    }
  }

  @override
  void dispose() {
    mainStore.setRouterSchedule = false;
    store.disposeStore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('mainStore.doctorId schedule page: ${mainStore.doctorId}');
    List<Widget> emptyState = <Widget>[];
    for (var i = 0; i < 10; i++) {
      emptyState.add(
        Container(
          height: wXD(30, context),
          width: wXD(71, context),
        ),
      );
      emptyState.add(SizedBox(height: wXD(15, context)));
    }
    return WillPopScope(
      onWillPop: () async {
        Modular.to.pop();
        store.disposeStore();
        return Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EncontrarCuidadoAppBar(
                  title: 'Agendar consulta',
                  onTap: () {
                    Modular.to.pop();
                    store.disposeStore();
                  }),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('doctors')
                    .doc(mainStore.doctorId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(height: wXD(100, context));
                  } else {
                    DocumentSnapshot doc = snapshot.data;
                    store.doctor = DoctorModel.fromDocument(doc);

                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        mainStore.setRouterSchedule = true;
                        if (widget.group.data) {
                          Modular.to.pop();
                        } else {
                          Modular.to.pushNamed('/drprofile',
                              arguments: DoctorModel.fromDocument(doc));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: wXD(14, context),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: wXD(20, context),
                            vertical: wXD(12, context)),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xff707070).withOpacity(.4),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: doc['avatar'] == null
                                      ? Image.asset(
                                          'assets/img/defaultUser.png',
                                          height: wXD(60, context),
                                          width: wXD(60, context),
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: doc['avatar'],
                                          width: wXD(60, context),
                                          height: wXD(60, context),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Container(
                                  width: maxWidth(context) * .7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: wXD(3, context),
                                          left: wXD(5, context),
                                        ),
                                        child: Text(
                                          '${doc['username']}',
                                          style: TextStyle(
                                            color: Color(0xff484D54),
                                            fontSize: wXD(16, context),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: wXD(8, context),
                                          top: wXD(2, context),
                                          bottom: wXD(2, context),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data[
                                                          'speciality_name'] ==
                                                      null
                                                  ? '- - -'
                                                  : snapshot
                                                      .data['speciality_name'],
                                              style: TextStyle(
                                                color: Color(0xff484D54),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: wXD(5, context),
                                                right: wXD(5, context),
                                                // bottom: wXD(3.5, context),
                                              ),
                                              height: wXD(6, context),
                                              width: wXD(6, context),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff484D54),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                            ),
                                            Flexible(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  doc['clinic_name'] == null
                                                      ? '- - -'
                                                      : doc['clinic_name'],
                                                  style: TextStyle(
                                                    color: Color(0xff484D54),
                                                    fontSize: wXD(14, context),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.star_rate_rounded,
                                            color: Color(0xffFBBD08),
                                            size: wXD(20, context),
                                          ),
                                          StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('doctors')
                                                .doc(snapshot.data.id)
                                                .collection('ratings')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              // print(
                                              //     'snaaaapshot raatings ${snapshot.data.docs}');
                                              if (snapshot.hasData) {
                                                double ratings = 0;
                                                QuerySnapshot ratingsQuery =
                                                    snapshot.data;
                                                ratingsQuery.docs
                                                    .forEach((element) {
                                                  ratings +=
                                                      element['avaliation'];
                                                });
                                                print('ratings: $ratings');
                                                print(
                                                    'docs.length: ${ratingsQuery.docs.length}');
                                                // print(
                                                //     'ratings/ docs.length: ${ratings / ratingsQuery.docs.length} ');
                                                String media =
                                                    ratingsQuery.docs.length ==
                                                            0
                                                        ? '0.0'
                                                        : (ratings /
                                                                ratingsQuery
                                                                    .docs
                                                                    .length)
                                                            .toString();
                                                return Row(
                                                  children: [
                                                    Text(
                                                      media
                                                          .toString()
                                                          .substring(0, 3),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff2185D0),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '  ${ratingsQuery.docs.length} opiniões',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff787C81),
                                                        fontSize:
                                                            wXD(14, context),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              Container(
                padding: EdgeInsets.only(bottom: wXD(12, context)),
                height: wXD(42, context),
                decoration: BoxDecoration(
                    color: Color(0xfffafafa),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 3,
                        color: Color(0x20000000),
                      )
                    ],
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(25))),
                alignment: Alignment.center,
                child: Text(
                  'Calendário',
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: wXD(20, context),
                      fontWeight: FontWeight.w500),
                ),
              ),
              Observer(
                builder: (context) {
                  return Column(
                    children: [
                      HourQueue(
                        nextDays: () {
                          store.setVisibleDates(
                              store.visibleDates.last.add(Duration(days: 1)));
                          store.setVisibleSchedules();
                          setState(() {});
                        },
                        previousDays: () {
                          store.setVisibleDates(store.visibleDates.first
                              .subtract(Duration(days: 3)));
                          store.setVisibleSchedules();
                          setState(() {});
                        },
                        days: store.visibleDates,
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('doctors')
                        .doc(mainStore.doctorId)
                        .collection('schedules')
                        // .where('status', isNotEqualTo: 'deleted')
                        .orderBy('start_hour', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.only(top: wXD(70, context)),
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        QuerySnapshot scheduleQuery = snapshot.data;
                        List<DocumentSnapshot> schedules = <DocumentSnapshot>[];
                        scheduleQuery.docs.forEach((DocumentSnapshot schedule) {
                          if (schedule['status'] != 'DELETED') {
                            schedules.add(schedule);
                          }
                        });
                        store.setSchedules(schedules.asObservable());
                        store.setVisibleSchedules();
                        if (scheduleQuery.docs.isEmpty || store.emptyState) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: wXD(60, context)),
                            child: EmptyStateList(
                              image: 'assets/img/pacient_communication.png',
                              title: 'Sem horários',
                              description:
                                  'Não há horários para serem exibidos a partir dessas datas',
                            ),
                          );
                        } else {
                          return Observer(
                            builder: (context) {
                              if (store.allIsEmpty) {
                                print('next date: ${store.nextDate}');
                                String nextMonthDay = store.nextDate.day
                                    .toString()
                                    .padLeft(2, '0');
                                String month = DateFormat('MMM', "pt_BR")
                                    .format(store.nextDate);
                                String monthFormated =
                                    month.substring(0, 1).toUpperCase() +
                                        month.substring(1, 3);
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: wXD(85, context)),
                                    child: Column(
                                      children: [
                                        Text('Próximo dia disponível:'),
                                        Text(
                                            '$nextMonthDay $monthFormated, ${TimeModel().hour(Timestamp.fromDate(store.nextDate))}'),
                                        GestureDetector(
                                          onTap: () {
                                            store.setVisibleDates(
                                                store.nextDate);
                                            setState(() {});
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: wXD(50, context)),
                                            height: wXD(38, context),
                                            width: wXD(260, context),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(7),
                                              ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xff41C3B3),
                                                  Color(0xff21BCCE),
                                                ],
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0x29000000),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Mostrar horas disponíveis',
                                                  style: TextStyle(
                                                      color: Color(0xfffafafa),
                                                      fontSize:
                                                          wXD(16, context)),
                                                ),
                                                SizedBox(
                                                  width: wXD(10, context),
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: wXD(18, context),
                                                  color: Color(0xfffafafa),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        wXD(27, context),
                                        wXD(13, context),
                                        wXD(27, context),
                                        wXD(13, context),
                                      ),
                                      child: Text(
                                        'Horários disponíveis',
                                        style: TextStyle(
                                          color: Color(0xff787C81),
                                          fontSize: wXD(13, context),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Spacer(flex: 5),
                                        Observer(builder: (context) {
                                          return Column(
                                            children: store.firstSchedules
                                                        .length ==
                                                    0
                                                ? emptyState
                                                : List.generate(
                                                    store.firstSchedules.length,
                                                    (index) =>
                                                        store.getAppointment(
                                                      store.firstSchedules[
                                                          index],
                                                    ),
                                                  ),
                                          );
                                        }),
                                        Spacer(flex: 3),
                                        Observer(builder: (context) {
                                          return Column(
                                            children: store.centerSchedules
                                                        .length ==
                                                    0
                                                ? emptyState
                                                : List.generate(
                                                    store
                                                        .centerSchedules.length,
                                                    (index) =>
                                                        store.getAppointment(
                                                      store.centerSchedules[
                                                          index],
                                                    ),
                                                  ),
                                          );
                                        }),
                                        Spacer(flex: 3),
                                        Observer(builder: (context) {
                                          return Column(
                                            children: store
                                                        .lastSchedules.length ==
                                                    0
                                                ? emptyState
                                                : List.generate(
                                                    store.lastSchedules.length,
                                                    (index) =>
                                                        store.getAppointment(
                                                      store
                                                          .lastSchedules[index],
                                                    ),
                                                  ),
                                          );
                                        }),
                                        Spacer(flex: 5),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        }
                      }
                    },
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

class Time extends StatelessWidget {
  final ScheduleModel schedule;
  final Function onTap;
  const Time({Key key, this.schedule, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _avaiable = true;
    if (schedule.availableVacancies == 0) {
      _avaiable = false;
    }
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: Container(
            // margin: EdgeInsets.only(bottom: wXD(15, context)),
            height: wXD(30, context),
            width: wXD(71, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.all(width: 2, color: Color(0xff41C3B3)),
              color: _avaiable ? Colors.transparent : Color(0xff41c3b3),
            ),
            alignment: Alignment.center,
            child: Text(TimeModel().hour(schedule.startHour),
                style: TextStyle(
                  color: _avaiable ? Color(0xff41c3b3) : Color(0xffffffff),
                  fontWeight: FontWeight.w500,
                )),
          ),
        ),
        SizedBox(height: wXD(15, context))
      ],
    );
  }
}

class Queue extends StatelessWidget {
  final ScheduleModel schedule;
  final Function onTap;
  const Queue({
    Key key,
    this.onTap,
    this.schedule,
  }) : super(key: key);

  String getQueue(ScheduleModel _schedule) {
    int _hour = _schedule.startHour.toDate().hour;
    if (_hour < 12) {
      return 'Manhã';
    } else if (_hour >= 12 && _hour < 18) {
      return 'Tarde';
    } else if (_hour >= 18 && _hour <= 23) {
      return 'Noite';
    } else {
      return 'Something is wrong';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _avaiable = true;
    if (schedule.availableVacancies == 0) {
      _avaiable = false;
    }
    TextStyle style = TextStyle(
      color: _avaiable ? Color(0xff41c3b3) : Color(0xffffffff),
      fontWeight: FontWeight.w500,
    );
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: Container(
            // margin: EdgeInsets.only(bottom: wXD(15, context)),
            height: wXD(105, context),
            width: wXD(71, context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(width: 2, color: Color(0xff41C3B3)),
                color: _avaiable ? Colors.transparent : Color(0xff41C3B3)),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(getQueue(schedule), style: style),
                SizedBox(height: wXD(5, context)),
                Text(TimeModel().hour(schedule.startHour), style: style),
                Text('às', style: style),
                Text(TimeModel().hour(schedule.endHour), style: style),
              ],
            ),
          ),
        ),
        SizedBox(height: wXD(15, context))
      ],
    );
  }
}
