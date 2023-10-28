import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/core/models/appointment_model.dart';
import 'package:encontrarCuidado/app/modules/main/widgets/set_cards.dart';
import 'package:encontrarCuidado/app/modules/messages/widgets/chat.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/information_tile.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'scheduling_store.dart';
import 'widgets/confirm_appointment.dart';
import 'widgets/doctor_appointment.dart';

class ConsulationDetail extends StatefulWidget {
  final AppointmentModel appointmentModel;

  const ConsulationDetail({
    Key key,
    this.appointmentModel,
  }) : super(key: key);
  @override
  _ConsulationDetailState createState() => _ConsulationDetailState();
}

class _ConsulationDetailState extends State<ConsulationDetail> {
  final SchedulingStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  String status;

  @override
  void initState() {
    status = widget.appointmentModel.status;
    store.getStatus(status, widget.appointmentModel.rescheduled);
    store.getAddress(widget.appointmentModel.doctorId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(store.mapStatus);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        if (mainStore.consultChat == true) {
          mainStore.consultChat = false;
        }
        mainStore.hasChat = false;
        Modular.to.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  EncontrarCuidadoAppBar(
                    onTap: () {
                      if (mainStore.consultChat == true) {
                        mainStore.consultChat = false;
                      }
                      mainStore.hasChat = false;
                      Modular.to.pop();
                    },
                    title: 'Detalhes da Consulta',
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWidget(
                            title: 'Seus Especialistas',
                            top: wXD(24, context),
                            left: wXD(18, context),
                            bottom: wXD(18, context),
                          ),
                          DoctorAppointment(
                            doctorId: widget.appointmentModel.doctorId,
                            onTap: () async {
                              await store.mainStore.hasChatWith(
                                  widget.appointmentModel.doctorId);

                              mainStore.setSelectedTrunk(3);
                              mainStore.consultChat = true;
                              Modular.to.pushNamed('/messages/chat');
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) =>
                              //             Chat()));
                              // Modular.to.pushNamed('/messages/chat');
                            },
                          ),
                          TitleWidget(
                            title: 'Paciente',
                            top: wXD(9, context),
                            left: wXD(18, context),
                            bottom: wXD(14, context),
                          ),
                          InformationTitle(
                            icon: Icons.person,
                            title: widget.appointmentModel.patientName,
                            color: Color(0xff484D54),
                            left: wXD(45, context),
                          ),
                          Separator(vertical: wXD(7, context)),
                          TitleWidget(
                            title: 'Detalhes',
                            top: wXD(9, context),
                            left: wXD(18, context),
                            bottom: wXD(14, context),
                          ),
                          InformationTitle(
                            icon: Icons.calendar_today,
                            title: store.getHour(widget.appointmentModel.hour),
                            color: Color(0xff484D54),
                            left: wXD(45, context),
                          ),
                          Separator(vertical: wXD(7, context)),
                          SizedBox(
                            height: wXD(13, context),
                          ),
                          InformationTitle(
                            icon: Icons.medical_services,
                            title: mainStore
                                .getVisitType(widget.appointmentModel.type),
                            color: Color(0xff484D54),
                            left: wXD(45, context),
                          ),
                          Separator(vertical: wXD(7, context)),
                          TitleWidget(
                            title: 'Preço',
                            top: wXD(9, context),
                            left: wXD(18, context),
                            bottom: wXD(14, context),
                          ),
                          InformationTitle(
                            icon: Icons.money,
                            title:
                                'R\$${formatedCurrency(widget.appointmentModel.price)}',
                            color: Color(0xff484D54),
                            left: wXD(45, context),
                          ),
                          Separator(vertical: wXD(7, context)),
                          TitleWidget(
                            title: 'Endereço da Clínica',
                            top: wXD(9, context),
                            left: wXD(18, context),
                            bottom: wXD(14, context),
                          ),
                          Observer(builder: (context) {
                            return InformationTitle(
                              icon: Icons.location_on,
                              title: store.address,
                              color: Color(0xff484D54),
                              left: wXD(45, context),
                            );
                          }),
                          Separator(vertical: wXD(7, context)),
                          widget.appointmentModel.status == 'CANCELED' ||
                                  widget.appointmentModel.status == 'ABSENT'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitleWidget(
                                      title: 'Observação',
                                      top: wXD(9, context),
                                      left: wXD(18, context),
                                      bottom: wXD(14, context),
                                    ),
                                    InformationTitle(
                                      icon: Icons.info_outline,
                                      title:
                                          'O valor da consulta pode ter sido alterado.',
                                      color: Color(0xff484D54),
                                      left: wXD(45, context),
                                    ),
                                    Separator(vertical: wXD(7, context)),
                                  ],
                                )
                              : Container(),
                          Observer(builder: (context) {
                            return store.mapStatus['noButton']
                                ? Container()
                                : Center(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        // store.showDialog = !store.showDialog;
                                        if (store.mapStatus['return']) {
                                          await store.editAppointment(
                                              widget.appointmentModel, context);
                                        } else {
                                          store.confirmOverlay = OverlayEntry(
                                            builder: (context) =>
                                                ConfirmAppointment(
                                              onConfirm: () async {
                                                await store.editAppointment(
                                                    widget.appointmentModel,
                                                    context);
                                              },
                                              onBack: () {
                                                store.confirmOverlay.remove();
                                              },
                                              svgWay:
                                                  "./assets/svg/calendarcancel.svg",
                                              text: store.mapStatus['cancel']
                                                  ? 'Tem certeza que deseja cancelar\na consulta?'
                                                  : store.mapStatus[
                                                          'rescheduling']
                                                      ? 'Deseja reagendar sua consulta?'
                                                      : 'Deseja realizar este retorno?',
                                            ),
                                          );
                                          Overlay.of(context)
                                              .insert(store.confirmOverlay);
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: wXD(25, context),
                                          bottom: wXD(47, context),
                                        ),
                                        height: wXD(47, context),
                                        width: wXD(240, context),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18)),
                                            border: Border.all(
                                              color: Color(0xff707070)
                                                  .withOpacity(.40),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(0, 3),
                                                blurRadius: 3,
                                                color: Color(0x30000000),
                                              )
                                            ],
                                            color: Color(0xfffafafa)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          store.mapStatus['cancel']
                                              ? 'Cancelar Consulta'
                                              : store.mapStatus['rescheduling']
                                                  ? 'Reagendar'
                                                  : 'Retorno',
                                          style: TextStyle(
                                            color: store.mapStatus['cancel']
                                                ? Color(0xffFF4444)
                                                : Color(0xff2185D0),
                                            fontWeight: FontWeight.w500,
                                            fontSize: wXD(18, context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          })
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SetCards()
            ],
          ),
        ),
      ),
    );
  }
}
