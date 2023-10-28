import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrarCuidado/app/core/models/appointment_model.dart';
import 'package:encontrarCuidado/app/core/models/time_model.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/schedule/schedule_store.dart';
import 'package:encontrarCuidado/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'scheduling_store.g.dart';

class SchedulingStore = _SchedulingStoreBase with _$SchedulingStore;

abstract class _SchedulingStoreBase with Store {
  final AuthStore authStore = Modular.get();
  final ScheduleStore scheduleStore = Modular.get();
  final MainStore mainStore = Modular.get();

  @observable
  int page = 1;
  @observable
  String address = '';
  @observable
  ObservableList listAppointments = [].asObservable();
  @observable
  QuerySnapshot queryAppointments;
  @observable
  bool showDialog = false;
  @observable
  OverlayEntry confirmOverlay;
  @observable
  ObservableMap mapStatus = ObservableMap();

  void getStatus(String status, bool rescheduled) {
    if (!rescheduled) {
      mapStatus = ObservableMap();
      bool cancel = status == 'AWAITING' || status == 'SCHEDULED';
      bool rescheduling = status == 'CANCELED' || status == 'ABSENT';
      bool boolReturn = status == 'AWAITING_RETURN';
      bool dontHaveButton = status == 'REFUSED' || status == 'CONCLUDED';

      mapStatus.putIfAbsent('cancel', () => cancel);
      mapStatus.putIfAbsent('rescheduling', () => rescheduling);
      mapStatus.putIfAbsent('return', () => boolReturn);
      mapStatus.putIfAbsent('noButton', () => dontHaveButton);
    } else {
      mapStatus = ObservableMap();
      mapStatus.putIfAbsent('cancel', () => false);
      mapStatus.putIfAbsent('rescheduling', () => false);
      mapStatus.putIfAbsent('return', () => false);
      mapStatus.putIfAbsent('noButton', () => true);
    }
  }

  void viewConsulationDetail(docAppointment) async {
    AppointmentModel appointmentModel =
        AppointmentModel.fromDocumentSnapshot(docAppointment);

    Modular.to.pushNamed('/consulation-detail', arguments: appointmentModel);
  }

  void getListAppointment() {
    getListAppointments(queryAppointments);
  }

  void getListAppointments(QuerySnapshot qs) {
    ObservableList newList = [].asObservable();

    queryAppointments = qs;
    switch (page) {
      case 1:
        qs.docs.forEach((DocumentSnapshot ds) {
          if (ds['status'] == 'SCHEDULED' || ds['status'] == 'AWAITING') {
            newList.add(ds);
          }
        });

        newList.sort((a, b) {
          return a['hour'].compareTo(b['hour']);
        });
        break;

      case 2:
        qs.docs.forEach((DocumentSnapshot ds) {
          if (ds['status'] != 'AWAITING' &&
              ds['status'] != 'SCHEDULED' &&
              ds['status'] != 'FIT_REQUESTED' &&
              ds['status'] != 'AWAITING_PAYMENT') {
            newList.add(ds);
          }
        });

        newList.sort((a, b) {
          return a['hour'].compareTo(b['hour']);
        });
        break;

      case 3:
        qs.docs.forEach((DocumentSnapshot ds) {
          if (ds['status'] == 'CANCELED' || ds['status'] == 'REFUSED') {
            newList.add(ds);
          }
        });

        newList.sort((a, b) {
          return a['hour'].compareTo(b['hour']);
        });
        break;

      default:
        break;
    }

    listAppointments = newList;
  }

  @action
  getAddress(String doctorId) {
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get()
        .then((doctor) {
      address = doctor['address'] != null ? doctor['address'] : 'Vazio';
    });
  }

  @action
  String getHour(Timestamp hour) {
    DateTime _hour = hour.toDate();

    String hourAndMinute = _hour.hour.toString().padLeft(2, '0') +
        ':' +
        _hour.minute.toString().padLeft(2, '0');

    String date = _hour.day.toString().padLeft(2, '0') +
        '/' +
        _hour.month.toString().padLeft(2, '0') +
        '/' +
        _hour.year.toString();

    return hourAndMinute + ' • ' + date;
  }

  @action
  String getDate(Timestamp date) {
    List<String> listDay = [
      '',
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo'
    ];

    List<String> listMonth = [
      '',
      'Janeiro',
      'Feverreiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    String day = listDay[date.toDate().weekday];
    String month = listMonth[date.toDate().month];

    return '$day, ${date.toDate().day} de $month de ${date.toDate().year}';
  }

  Future editAppointment(AppointmentModel appointment, context) async {
    OverlayEntry loadOverlay;
    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
    if (!mapStatus['return']) {
      Overlay.of(context).insert(loadOverlay);
    }
    print(mapStatus);
    mainStore.setDoctorId(appointment.doctorId);

    print('xxxxxxxxxxxxxxxxx mapStatus $mapStatus');

    print('xxxxxxxxxxxxxxxxx doctorId  ${mainStore.doctorId}');

    if (appointment.type == 'RETURN') {
      DocumentSnapshot _appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointment.id)
          .get();

      DocumentSnapshot _returnAppointment = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(_appointmentDoc['appointment_id'])
          .get();

      mainStore.appointmentReturn =
          AppointmentModel.fromDocumentSnapshot(_returnAppointment);
      mainStore.returning = true;
    }

    if (mapStatus['cancel']) {
      await cancelConsulation(appointment);
      loadOverlay.remove();
      confirmOverlay.remove();
    } else if (mapStatus['rescheduling']) {
      if (await mainStore.getCards()) {
        mainStore.appointmentReschedule = appointment;
        mainStore.reschedule = true;
        mainStore.rescheduleId = appointment.id;
        loadOverlay.remove();
        confirmOverlay.remove();
        await Modular.to.pushNamed('/schedule', arguments: false);
      } else {
        loadOverlay.remove();
        confirmOverlay.remove();
        mainStore.setCards = true;
      }
    } else if (mapStatus['return']) {
      mainStore.appointmentReturn = appointment;
      mainStore.returning = true;
      await Modular.to.pushNamed('/schedule', arguments: false);
    }
  }

  cancelConsulation(AppointmentModel appointment) async {
    DocumentSnapshot _appointmentDoc = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointment.id)
        .get();

    DocumentSnapshot _appointmentDocPat = await FirebaseFirestore.instance
        .collection('patients')
        .doc(appointment.patientId)
        .collection('appointments')
        .doc(appointment.id)
        .get();

    await _appointmentDoc.reference.update({'status': 'CANCELED'});

    await _appointmentDocPat.reference.update({'status': 'CANCELED'});

    DocumentSnapshot scheduleDoctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(appointment.doctorId)
        .collection('schedules')
        .doc(appointment.scheduleId)
        .get();

    DocumentSnapshot scheduleDoc = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(appointment.scheduleId)
        .get();

    await scheduleDoctorDoc.reference.update({
      'occupied_vacancies': (scheduleDoctorDoc['occupied_vacancies'] - 1),
    });

    await scheduleDoc.reference.update({
      'occupied_vacancies': (scheduleDoc['occupied_vacancies'] - 1),
    });

    if (appointment.type != 'FIT') {
      await scheduleDoctorDoc.reference.update({
        'available_vacancies': (scheduleDoctorDoc['available_vacancies'] + 1),
      });
      await scheduleDoc.reference.update({
        'available_vacancies': (scheduleDoc['available_vacancies'] + 1),
      });
    }

    QuerySnapshot infoQuery =
        await FirebaseFirestore.instance.collection('info').get();

    DocumentSnapshot infoDoc = infoQuery.docs.first;

    await infoDoc.reference.update({'timestamp': FieldValue.serverTimestamp()});

    DateTime nowDate = infoDoc['timestamp'].toDate();

    DateTime appointmentDate = _appointmentDoc['hour'].toDate();

    print(
        '%%%%%%%%%%%%%% ahhhhhhh ${appointmentDate.difference(nowDate).inDays} $nowDate - $appointmentDate %%%%%%%%%%%%%%');

    if (appointmentDate.difference(nowDate).inDays >= 2) {
      QuerySnapshot doctorTransactions = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(appointment.doctorId)
          .collection('transactions')
          .where('appointment_id', isEqualTo: appointment.id)
          .get();

      doctorTransactions.docs.forEach((element) {
        print('xxxxxx forEach doctorTransactions ${element['status']}');
        if (element['status'] != 'REFUND' &&
            element['status'] != 'PENDING_REFUND') {
          element.reference.update({
            'status': 'PENDING_REFUND',
            'updated_at': FieldValue.serverTimestamp(),
          });
        }
      });

      QuerySnapshot patientTransactions = await FirebaseFirestore.instance
          .collection('patients')
          .doc(appointment.patientId)
          .collection('transactions')
          .where('appointment_id', isEqualTo: appointment.id)
          .get();

      patientTransactions.docs.forEach((element) {
        print('xxxxxx forEach patientTransactions ${element['status']}');
        if (element['status'] != 'REFUND' &&
            element['status'] != 'PENDING_REFUND') {
          element.reference.update({
            'status': 'PENDING_REFUND',
            'updated_at': FieldValue.serverTimestamp(),
          });
        }
      });

      QuerySnapshot transactions = await FirebaseFirestore.instance
          .collection('transactions')
          .where('appointment_id', isEqualTo: appointment.id)
          .get();

      transactions.docs.forEach((element) {
        print('xxxxxx forEach transactions ${element['status']}');
        if (element['status'] != 'REFUND' &&
            element['status'] != 'PENDING_REFUND') {
          element.reference.update({
            'status': 'PENDING_REFUND',
            'updated_at': FieldValue.serverTimestamp(),
          });
        }
      });
    }

    // FirebaseFunctions functions = FirebaseFunctions.instance;
    // functions.useFunctionsEmulator('localhost', 5001);
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('cancelNotification');
    try {
      Map data = {
        'patientId': appointment.patientId,
        'doctorId': appointment.doctorId,
        'appointmentId': appointment.id,
        'hourString': TimeModel().hour(appointment.hour),
        'dateString': TimeModel().date(appointment.date),
      };
      print('Data: $data');
      callable.call(<String, dynamic>{
        'patientId': appointment.patientId,
        'doctorId': appointment.doctorId,
        'appointmentId': appointment.id,
        'hourString': TimeModel().hour(appointment.hour),
        'dateString': TimeModel().date(appointment.date),
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
    Modular.to.pop();
  }
}
