import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrarCuidado/app/core/models/appointment_model.dart';
import 'package:encontrarCuidado/app/core/models/doctor_model.dart';
import 'package:encontrarCuidado/app/core/models/schedule_model.dart';
import 'package:encontrarCuidado/app/core/models/time_model.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/widgets/confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'schedule_page.dart';
part 'schedule_store.g.dart';

class ScheduleStore = _ScheduleStoreBase with _$ScheduleStore;

abstract class _ScheduleStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  DoctorModel doctor;
  @observable
  ScheduleModel scheduleSelected;
  @observable
  bool allIsEmpty = false;
  @observable
  bool emptyState = false;
  @observable
  bool onEditing = false;
  @observable
  bool covidSymptoms = false;
  @observable
  bool firstAppointment = false;
  @observable
  bool appointmentCircular = false;
  @observable
  String note = '';
  @observable
  String patientName = '';
  @observable
  String countyNum = '';
  @observable
  String phone = '';
  @observable
  String dependentId = '';
  @observable
  double price = 0.0;
  @observable
  DateTime nextDate;
  @observable
  ObservableList visibleDates = <DateTime>[].asObservable();
  @observable
  ObservableList schedules = <DocumentSnapshot>[].asObservable();
  @observable
  ObservableList firstSchedules = <ScheduleModel>[].asObservable();
  @observable
  ObservableList centerSchedules = <ScheduleModel>[].asObservable();
  @observable
  ObservableList lastSchedules = <ScheduleModel>[].asObservable();

  @action
  setSchedules(_schedules) => schedules = _schedules;
  @action
  setAllIsEmpty(_allIsEmpty) => allIsEmpty = _allIsEmpty;
  @action
  setOnEditing(bool _onEditing) => onEditing = _onEditing;
  @action
  setCovidSymptoms(bool _covidSymptoms) => covidSymptoms = _covidSymptoms;
  @action
  setFirstAppointment(bool _firstAppointment) =>
      firstAppointment = _firstAppointment;
  @action
  setNote(String _note) => note = _note;
  @action
  setPatientName(String _patientName) => patientName = _patientName;

  @action
  setVisibleDates(DateTime _date) {
    List<DateTime> _dates = <DateTime>[];
    for (var i = 0; i < 3; i++) {
      _dates.add(_date.add(Duration(days: i)));
    }
    visibleDates = _dates.asObservable();
  }

  void disposeStore() {
    Future.delayed(Duration(milliseconds: 500));
    scheduleSelected = ScheduleModel();
    mainStore.appointmentReschedule = AppointmentModel();
    mainStore.appointmentReturn = AppointmentModel();

    allIsEmpty = false;
    emptyState = false;
    onEditing = false;
    mainStore.returning = false;
    mainStore.reschedule = false;
    covidSymptoms = false;
    firstAppointment = false;

    note = '';
    patientName = '';
    countyNum = '';
    phone = '';
    dependentId = '';
    price = 0.0;

    nextDate = DateTime(0);

    // visibleDates = <DateTime>[].asObservable();
    schedules = <DocumentSnapshot>[].asObservable();
    firstSchedules = <ScheduleModel>[].asObservable();
    centerSchedules = <ScheduleModel>[].asObservable();
    lastSchedules = <ScheduleModel>[].asObservable();
  }

  @action
  setVisibleSchedules() {
    ObservableList _firstSchedules = <ScheduleModel>[].asObservable();
    ObservableList _centerSchedules = <ScheduleModel>[].asObservable();
    ObservableList _lastSchedules = <ScheduleModel>[].asObservable();

    String firstDate = visibleDates.first.toString().substring(0, 10);
    String halfDate = visibleDates[1].toString().substring(0, 10);
    String lastDate = visibleDates.last.toString().substring(0, 10);

    schedules.forEach((_scheduleDoc) {
      ScheduleModel schedule = ScheduleModel.fromDocumentSnapshot(_scheduleDoc);
      String scheduleDate =
          schedule.startHour.toDate().toString().substring(0, 10);
      if (scheduleDate == firstDate) {
        _firstSchedules.add(schedule);
      } else if (scheduleDate == halfDate) {
        _centerSchedules.add(schedule);
      } else if (scheduleDate == lastDate) {
        _lastSchedules.add(schedule);
      }
    });

    _firstSchedules.sort((a, b) {
      return a.startHour.compareTo(b.startHour);
    });
    _centerSchedules.sort((a, b) {
      return a.startHour.compareTo(b.startHour);
    });
    _lastSchedules.sort((a, b) {
      return a.startHour.compareTo(b.startHour);
    });

    firstSchedules = _firstSchedules;
    centerSchedules = _centerSchedules;
    lastSchedules = _lastSchedules;

    bool hasAfterDate = false;
    schedules.reversed.forEach((element) {
      if (element['end_hour'].toDate().isAfter(DateTime.now()
              .subtract(Duration(hours: 3))
              .add(Duration(minutes: 30))) &&
          element['available_vacancies'] > 0 &&
          element['end_hour'].toDate().isAfter(visibleDates.last)) {
        hasAfterDate = true;
        nextDate = element['start_hour'].toDate();
        // print('nextDate: $nextDate');
      }
    });
    // print('nextDate: $nextDate');

    if (firstSchedules.isEmpty &&
        centerSchedules.isEmpty &&
        lastSchedules.isEmpty) {
      setAllIsEmpty(true);
      if (!hasAfterDate) {
        emptyState = true;
      }
    } else {
      setAllIsEmpty(false);
      emptyState = false;
    }
  }

  getAppointment(ScheduleModel schedule) {
    bool _avaiable = true;
    if (schedule.availableVacancies == 0) {
      _avaiable = false;
    }
    if (schedule.type == 'DEFAULT') {
      return Time(
        schedule: schedule,
        onTap: () async {
          if (_avaiable) {
            if (schedule.startHour.toDate().isAfter(DateTime.now())) {
              scheduleSelected = schedule;
              if (mainStore.reschedule && !mainStore.returning) {
                Modular.to.pushNamed('/schedule/reschedule',
                    arguments: schedule.doctorId);
              } else if (mainStore.returning) {
                DateTime date = mainStore.appointmentReturn.date.toDate();
                DateTime maxDateAppointment =
                    DateTime(date.year, date.month, date.day)
                        .add(Duration(days: doctor.returnPeriod + 1));

                if (schedule.date.toDate().isAfter(maxDateAppointment)) {
                  Fluttertoast.showToast(
                      msg:
                          'O prazo de retorno deste doutor é de até no maximo ${doctor.returnPeriod} dias!!',
                      backgroundColor: Colors.red[400]);
                } else {
                  if (mainStore.reschedule) {
                    Modular.to.pushNamed('/schedule/reschedule',
                        arguments: schedule.doctorId);
                  } else {
                    Modular.to.pushNamed('/schedule/confirm-appointment');
                  }
                }
              } else {
                Modular.to.pushNamed('/schedule/confirm-appointment');
              }
            } else {
              Fluttertoast.showToast(
                  msg: 'Horário indisponível',
                  backgroundColor: Colors.red[400]);
            }
          } else {
            Fluttertoast.showToast(
                msg: 'Não há mais vagas disponíveis neste horário',
                backgroundColor: Colors.red[400]);
          }
        },
      );
    } else if (schedule.type == 'QUEUE') {
      return Queue(
        schedule: schedule,
        onTap: () async {
          if (_avaiable) {
            if (schedule.startHour.toDate().isAfter(DateTime.now())) {
              scheduleSelected = schedule;
              if (mainStore.reschedule && !mainStore.returning) {
                Modular.to.pushNamed('/schedule/reschedule',
                    arguments: schedule.doctorId);
              } else if (mainStore.returning) {
                DateTime date = mainStore.appointmentReturn.date.toDate();
                DateTime maxDateAppointment =
                    DateTime(date.year, date.month, date.day)
                        .add(Duration(days: doctor.returnPeriod + 1));

                if (schedule.date.toDate().isAfter(maxDateAppointment)) {
                  Fluttertoast.showToast(
                      msg:
                          'O prazo de retorno deste doutor é de até no maximo ${doctor.returnPeriod} dias!!',
                      backgroundColor: Colors.red[400]);
                } else {
                  if (mainStore.reschedule) {
                    Modular.to.pushNamed('/schedule/reschedule',
                        arguments: schedule.doctorId);
                  } else {
                    Modular.to.pushNamed('/schedule/confirm-appointment');
                  }
                }
              } else {
                Modular.to.pushNamed('/schedule/confirm-appointment');
              }
            } else {
              Fluttertoast.showToast(
                  msg: 'Período indisponível',
                  backgroundColor: Colors.red[400]);
            }
          } else {
            Fluttertoast.showToast(
                msg: 'Não há mais vagas disponíveis neste período',
                backgroundColor: Colors.red[400]);
          }
        },
      );
    }
  }

  Future<String> getHasAppointment(
      {String scheduleId,
      int index,
      String titularId,
      String dependentId}) async {
    QuerySnapshot appointmentVerify;
    String textError;

    if (index == 0) {
      appointmentVerify = await FirebaseFirestore.instance
          .collection('patients')
          .doc(mainStore.authStore.user.uid)
          .collection('appointments')
          .where('schedule_id', isEqualTo: scheduleId)
          .where('patient_id', isEqualTo: titularId)
          .get();
    } else {
      appointmentVerify = await FirebaseFirestore.instance
          .collection('patients')
          .doc(mainStore.authStore.user.uid)
          .collection('appointments')
          .where('schedule_id', isEqualTo: scheduleId)
          .where('dependent_id', isEqualTo: dependentId)
          .get();
    }

    for (var i = 0; i < appointmentVerify.docs.length; i++) {
      DocumentSnapshot appointmentDoc = appointmentVerify.docs[i];
      if (index == 0) {
        if (appointmentDoc['dependent_id'] == null) {
          if (appointmentDoc['status'] == 'SCHEDULED') {
            textError = 'Você já está cadastrado nesse horário.';
            break;
          }
          if (appointmentDoc['status'] == 'FIT_REQUESTED') {
            textError = 'Você tem um encaixe pendente para esse horário.';
            break;
          }
        }
      } else {
        if (appointmentDoc['status'] == 'SCHEDULED') {
          textError = 'Esse dependente já está cadastrado nesse horário.';
          break;
        }
        if (appointmentDoc['status'] == 'FIT_REQUESTED') {
          textError =
              'Esse dependente tem um encaixe pendente para esse horário.';
          break;
        }
      }
    }

    return textError;
  }

  confirmAppointment(int index, BuildContext context, String doctorId) async {
    print('cccccccccccc confirmAppointment $index - $doctorId');
    appointmentCircular = true;

    String _titularId = mainStore.authStore.user.uid;
    String _dependentId = mainStore.returning
        ? mainStore.appointmentReturn.dependentId
        : mainStore.reschedule
            ? mainStore.appointmentReschedule.dependentId
            : index == 0
                ? null
                : dependentId;

    AppointmentModel _appointment = AppointmentModel(
      note: note == '' ? null : note,
      contact: countyNum +
          phone
              .replaceAll(RegExp(' '), '')
              .replaceAll(RegExp('-'), '')
              .replaceAll('(', '')
              .replaceAll(')', ''),
      patientName: mainStore.reschedule
          ? mainStore.appointmentReschedule.patientName
          : patientName,
      covidSymptoms: covidSymptoms,
      firstVisit: firstAppointment,
      createdAt: Timestamp.now(),
      date: scheduleSelected.date,
      hour: scheduleSelected.startHour,
      endHour: scheduleSelected.endHour,
      doctorId: doctorId,
      scheduleId: scheduleSelected.id,
      patientId: _titularId,
      dependentId: _dependentId,
      id: '',
      status: 'AWAITING_PAYMENT',
      type: mainStore.returning ? 'RETURN' : 'SCHEDULE',
      price: mainStore.returning ? 0 : price,
      rated: false,
      canceledByDoctor: false,
      rescheduled: false,
    );

    DocumentSnapshot _patient = await FirebaseFirestore.instance
        .collection('patients')
        .doc(mainStore.authStore.user.uid)
        .get();

    DocumentSnapshot _doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();

    DocumentReference _appointmentPatDoc = await _patient.reference
        .collection('appointments')
        .add(AppointmentModel().toJson(_appointment));

    print('cccccccccccc confirmAppointment2');

    try {
      print('xxxxxxxxxxxx try $index xxxxxxxxxxxxxx');
      _appointment.id = _appointmentPatDoc.id;

      String textError = await getHasAppointment(
        scheduleId: scheduleSelected.id,
        index: index,
        titularId: _titularId,
        dependentId: _dependentId,
      );

      if (textError != null) {
        flutterToast(textError);
        appointmentCircular = false;
      } else {
        Future<void> concludedAppointment() async {
          if (mainStore.reschedule) {
            FirebaseFirestore.instance
                .collection('appointments')
                .doc(mainStore.rescheduleId)
                .update({"rescheduled": true, "canceled_by_doctor": false});

            _patient.reference
                .collection('appointments')
                .doc(mainStore.rescheduleId)
                .update({"rescheduled": true, "canceled_by_doctor": false});

            mainStore.rescheduleId = null;
            mainStore.popUpRescheduleRequest = false;
          }

          await _appointmentPatDoc
              .update({'id': _appointmentPatDoc.id, "status": "SCHEDULED"});

          _appointment.status = 'SCHEDULED';

          await FirebaseFirestore.instance
              .collection('appointments')
              .doc(_appointmentPatDoc.id)
              .set(AppointmentModel().toJson(_appointment));

          // if (returning && !returnPeriodPassed) {
          if (mainStore.returning) {
            await FirebaseFirestore.instance
                .collection('appointments')
                .doc(_appointmentPatDoc.id)
                .update({'appointment_id': mainStore.appointmentReturn.id});

            _appointmentPatDoc
                .update({'appointment_id': mainStore.appointmentReturn.id});

            await FirebaseFirestore.instance
                .collection('appointments')
                .doc(mainStore.appointmentReturn.id)
                .update({'status': 'CONCLUDED'});

            await FirebaseFirestore.instance
                .collection('patients')
                .doc(mainStore.authStore.user.uid)
                .collection('appointments')
                .doc(mainStore.appointmentReturn.id)
                .update({'status': 'CONCLUDED'});
          }

          await _doctor.reference
              .collection('schedules')
              .doc(scheduleSelected.id)
              .get()
              .then((value) => value.reference.update({
                    'available_vacancies': value['available_vacancies'] - 1,
                    'occupied_vacancies': value['occupied_vacancies'] + 1,
                  }));

          await FirebaseFirestore.instance
              .collection('schedules')
              .doc(scheduleSelected.id)
              .get()
              .then((value) => value.reference.update({
                    'available_vacancies': value['available_vacancies'] - 1,
                    'occupied_vacancies': value['occupied_vacancies'] + 1,
                  }));

          String weekDay = DateFormat(DateFormat.WEEKDAY, 'pt_Br')
              .format(scheduleSelected.startHour.toDate());

          String weekDayFormated =
              weekDay.substring(0, 1).toUpperCase() + weekDay.substring(1);

          String monthDay = scheduleSelected.startHour
              .toDate()
              .day
              .toString()
              .padLeft(2, '0');

          List<String> listMonth = [
            '',
            'janeiro',
            'feverreiro',
            'março',
            'abril',
            'maio',
            'junho',
            'julho',
            'agosto',
            'setembro',
            'outubro',
            'novembro',
            'dezembro',
          ];

          String hour = TimeModel().hour(scheduleSelected.startHour);

          String month = listMonth[scheduleSelected.startHour.toDate().month];

          int indexMonth = scheduleSelected.startHour.toDate().month;

          HttpsCallable confirmAppointment =
              FirebaseFunctions.instance.httpsCallable('confirmAppointment');
          try {
            DateTime hoursAfter = scheduleSelected.startHour
                .toDate()
                .subtract(Duration(hours: 2));
            Timestamp stampHousAfter = Timestamp.fromDate(hoursAfter);
            print('no try');
            await confirmAppointment.call({
              'senderId': doctorId,
              'receiverId': _patient.id,
              'dateString':
                  monthDay + '/' + indexMonth.toString().padLeft(2, '0'),
              'hourString': hour,
              'hour': {
                'seconds': stampHousAfter.seconds,
                'nanoseconds': stampHousAfter.nanoseconds
              },
              'appointmentId': _appointmentPatDoc.id,
            });
          } on FirebaseFunctionsException catch (e) {
            print('caught firebase functions exception');
            print(e);
            print(e.code);
            print(e.message);
            print(e.details);
          } catch (e) {
            print('caught generic exception');
            print(e);
          }

          print('xxxxxxxxxxxxxxxxxxxxxx navigator ${mainStore.reschedule}');

          appointmentCircular = false;

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Confirmation(
                  callBack: disposeStore,
                  routerConfirmAppoiment: !mainStore.reschedule,
                  routerReschedule: mainStore.reschedule,
                  subTitle:
                      'Você receberá um lembrete antes da visita.\n$weekDayFormated, $monthDay de $month às $hour horas.',
                  title: index == 0
                      ? 'Sua consulta foi agendada\ncom sucesso'
                      : 'A consulta do dependente \nfoi agendada com sucesso',
                );
              },
            ),
          );

          print('acabou');
        }

        if (mainStore.returning) {
          // se o paciente estiver marcando um retorno não precisa efetuar pagamento.
          await concludedAppointment();
        } else {
          print('zxzzzzzzzzzzzzz else');

          bool guaranteeRefund = true;

          // caso seja um reagendamento é validado se ele reembolsou a caução, se sim é cobrado de novo.
          if (mainStore.reschedule) {
            print('xxxxxxsssssssssss if');
            QuerySnapshot transactions = await FirebaseFirestore.instance
                .collection('transactions')
                .where('appointment_id',
                    isEqualTo: mainStore.appointmentReschedule.id)
                .orderBy('created_at', descending: true)
                .get();

            print('xxxxxxsssssssssss transactions ${transactions.docs.length}');

            transactions.docs.forEach((element) {
              print(
                  'zzzzzzzzzzz forEach ${element['type']} - ${element['status']}');
              if (element['type'] == 'GUARANTEE_REFUND') {
                guaranteeRefund = true;
              } else {
                if (element['type'] == 'GUARANTEE') {
                  if (element['status'] == 'PENDING_REFUND') {
                    guaranteeRefund = true;
                  } else {
                    guaranteeRefund = false;
                  }
                }
              }
            });
          }

          print('zzzzzzzzzzzzz guaranteeRefund $guaranteeRefund');

          // caso seja um reagendamento onde a caução foi estornada, ou caso seja uma consulta nornal o caução é cobrado.
          if ((guaranteeRefund && mainStore.reschedule) ||
              (!mainStore.reschedule)) {
            num percent = 0;
            if (price >= 1) {
              String val = (price * 0.3).toStringAsFixed(2);
              percent = double.parse(val);
            }

            print('xxxxxxxxxxxx functions xxxxxxxxxxxxxxx');
            FirebaseFunctions functions = FirebaseFunctions.instance;
            // functions.useFunctionsEmulator('localhost', 5001);
            HttpsCallable callableSecurityDeposit =
                functions.httpsCallable('securityDeposit');
            // try {
            HttpsCallableResult<String> error =
                await callableSecurityDeposit.call({
              'patientId': _patient.id,
              'price': percent,
              'appointmentId': _appointmentPatDoc.id,
              'doctorId': doctorId,
              'remaining': false,
            });

            print('ssssssss error: ${error.data} sssssssss');

            if (error.data != null) {
              String text = 'Não foi possível efetuar o pagamento.';

              flutterToast(text);
              appointmentCircular = false;

              DocumentSnapshot appointmentDoc = await _patient.reference
                  .collection('appointments')
                  .doc(_appointment.id)
                  .get();

              if (appointmentDoc.exists) {
                await _patient.reference
                    .collection('appointments')
                    .doc(_appointmentPatDoc.id)
                    .delete();
              }
            } else {
              await concludedAppointment();
            }
          } else {
            await concludedAppointment();
          }
        }
      }
    } catch (e) {
      String text = 'Não foi possível efetuar o pagamento.';

      flutterToast(text);
      appointmentCircular = false;

      DocumentSnapshot appointmentDoc = await _patient.reference
          .collection('appointments')
          .doc(_appointment.id)
          .get();

      if (appointmentDoc.exists) {
        await _patient.reference
            .collection('appointments')
            .doc(_appointment.id)
            .delete();
      }
      print('Erroooo $e');
      print('Errooooopoo ${e.toString()}');
    }
  }
}

void flutterToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xff41C3B3),
      textColor: Colors.black,
      fontSize: 16.0);
}
