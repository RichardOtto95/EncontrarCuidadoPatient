import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/schedulings/scheduling_store.dart';
import 'package:encontrarCuidado/app/modules/schedulings/widgets/previous_scheduling.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'next_scheduling.dart';
import 'widgets/canceled_scheduling.dart';
import 'widgets/scheduling_empty_state.dart';

class SchedulingPage extends StatefulWidget {
  @override
  SchedulingPageState createState() => SchedulingPageState();
}

class SchedulingPageState
    extends ModularState<SchedulingPage, SchedulingStore> {
  final MainStore mainStore = Modular.get();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    handleScroll();
    super.initState();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        mainStore.setShowNav(false);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EncontrarCuidadoNavBar(
                  leading: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: wXD(18, context), right: wXD(11, context)),
                          child: Container()),
                      Text(
                        'Agendamentos',
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: wXD(20, context),
                        ),
                      ),
                    ],
                  ),
                ),
                appointmentsNavigator(),
                Expanded(
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.direction < 0) {
                        print('menor');

                        mainStore.setShowNav(false);
                      }
                      if (details.delta.direction > 0) {
                        print('maior');

                        mainStore.setShowNav(true);
                      }
                    },
                    child: SingleChildScrollView(
                        controller: scrollController, child: getPage()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getPage() {
    Widget emptyState() {
      return Container(
        alignment: Alignment.center,
        child: SchedulingEmptyState(
          image: './assets/svg/calendar.svg',
          description: store.page == 1
              ? 'Sem consultas agendadas'
              : store.page == 2
                  ? 'Sem consultas anteriores'
                  : 'Sem consultas canceladas',
        ),
      );
    }

    return Column(children: [
      SizedBox(height: wXD(20, context)),
      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('patients')
              .doc(store.authStore.user.uid)
              .collection('appointments')
              .snapshots(),
          builder: (context, snapshotAppointments) {
            if (!snapshotAppointments.hasData) {
              return Container();
            }

            if (snapshotAppointments.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              store.getListAppointments(snapshotAppointments.data);
            });

            return Observer(builder: (context) {
              if (store.listAppointments.isEmpty) {
                return emptyState();
              } else {
                return Column(
                  children:
                      List.generate(store.listAppointments.length, (index) {
                    var appointment = store.listAppointments[index];
                    String appointmentId = '';
                    appointmentId = appointment.id
                        .substring(
                            appointment.id.length - 4, appointment.id.length)
                        .toUpperCase();

                    if (store.page == 1) {
                      return NextScheduling(
                        appointmentId: appointmentId,
                        status: appointment['status'],
                        store: store,
                        timestamp: appointment['hour'],
                        doctorId: appointment['doctor_id'],
                        viewConsulationDetail: () =>
                            store.viewConsulationDetail(appointment),
                      );
                    } else if (store.page == 2) {
                      return PreviousScheduling(
                        appointmentId: appointmentId,
                        store: store,
                        status: appointment['status'],
                        date: appointment['hour'],
                        doctorId: appointment['doctor_id'],
                        viewConsulationDetail: () =>
                            store.viewConsulationDetail(appointment),
                      );
                    } else if (store.page == 3) {
                      return CanceledScheduling(
                        appointmentId: appointmentId,
                        status: appointment['status'],
                        store: store,
                        date: appointment['hour'],
                        doctorId: appointment['doctor_id'],
                        viewConsulationDetail: () =>
                            store.viewConsulationDetail(appointment),
                      );
                    } else {
                      return Container(child: Text('Erro de navegação'));
                    }
                  }),
                );
              }
            });
          }),
    ]);
  }

  Widget appointmentsNavigator() {
    return Observer(builder: (context) {
      return Container(
        padding: EdgeInsets.only(
            top: wXD(20, context),
            left: wXD(17, context),
            right: wXD(17, context)),
        child: Row(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (store.page != 1) {
                  store.page = 1;
                  store.getListAppointment();
                }
              },
              child: Container(
                height: wXD(39, context),
                width: wXD(142, context),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      store.page == 1 ? Color(0xff41c3b3) : Colors.transparent,
                      store.page == 1 ? Color(0xff21bcce) : Colors.transparent,
                    ],
                  ),
                  border: store.page == 1
                      ? Border.all(
                          width: 2,
                          color: Color(0xff41c3b3),
                        )
                      : Border(),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Próximas consultas',
                  style: TextStyle(
                    color:
                        store.page == 1 ? Color(0xfffafafa) : Color(0xff41c3b3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Spacer(),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (store.page != 2) {
                  store.page = 2;
                  store.getListAppointment();
                }
              },
              child: Container(
                height: wXD(39, context),
                width: wXD(90, context),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      store.page == 2 ? Color(0xff41c3b3) : Colors.transparent,
                      store.page == 2 ? Color(0xff21bcce) : Colors.transparent,
                    ],
                  ),
                  border: store.page == 2
                      ? Border.all(
                          width: 2,
                          color: Color(0xff41c3b3),
                        )
                      : Border(),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Anteriores',
                  style: TextStyle(
                    color:
                        store.page == 2 ? Color(0xfffafafa) : Color(0xff41c3b3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Spacer(),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (store.page != 3) {
                  store.page = 3;
                  store.getListAppointment();
                }
              },
              child: Container(
                height: wXD(39, context),
                width: wXD(90, context),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      store.page == 3 ? Color(0xff41c3b3) : Colors.transparent,
                      store.page == 3 ? Color(0xff21bcce) : Colors.transparent,
                    ],
                  ),
                  border: store.page == 3
                      ? Border.all(
                          width: 2,
                          color: Color(0xff41c3b3),
                        )
                      : Border(),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Canceladas',
                  style: TextStyle(
                    color:
                        store.page == 3 ? Color(0xfffafafa) : Color(0xff41c3b3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
