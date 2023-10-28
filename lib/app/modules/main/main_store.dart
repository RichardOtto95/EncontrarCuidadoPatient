import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrarCuidado/app/core/models/appointment_model.dart';
import 'package:encontrarCuidado/app/core/models/time_model.dart';
import 'package:encontrarCuidado/app/core/modules/root/root_store.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:encontrarCuidado/app/modules/schedule/schedule_store.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/fit_requested_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
part 'main_store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store {
  final AuthStore authStore = Modular.get();
  final RootStore rootStore = Modular.get();
  @observable
  bool reschedule = false;
  @observable
  String rescheduleId = '';
  @observable
  bool returning = false;
  @observable
  AppointmentModel appointmentReschedule;
  @observable
  AppointmentModel appointmentReturn;
  @observable
  AppointmentModel appointment;
  @observable
  int value = 0;
  @observable
  int selectedTrunk = 0;
  @observable
  bool showNavigator = true;
  @observable
  String specName = '';
  @observable
  String specialityID = '';
  @observable
  bool noHistoric = false;
  @observable
  bool emptyStatePayment = false;
  @observable
  bool setRouterSchedule = false;
  @observable
  String doctorId = '';
  @observable
  DocumentSnapshot userSnap;
  @observable
  String supportId = '';
  @observable
  Stream<QuerySnapshot> supportStream;
  @observable
  QuerySnapshot support;
  @observable
  QuerySnapshot info;
  @observable
  String nullSpeciality;
  @observable
  bool consultChat = false;
  @observable
  bool hasChat = false;
  @observable
  String doctorID;
  @observable
  String drAvatar;
  @observable
  DocumentSnapshot profileChat;
  @observable
  String chatName;
  @observable
  bool feedRoute = false, setCards = false, loadCircularSetCards = false;
  @observable
  Stream<QuerySnapshot> chatStream;
  @observable
  bool popUpRating = false;
  @observable
  String doctorName = 'Nome do doutor';
  @observable
  String doctorPhoto;
  @observable
  String textRating;
  @observable
  String appointmentIdRating;
  @observable
  double valueRating = 3;
  @observable
  String doctorIdRating;
  @observable
  bool popUpRescheduleRequest = false, loadCircularReschedule = false;
  @observable
  String textPopUpReschedule = 'consulta cancelada';
  @observable
  bool setRouterSearch = false;
  @observable
  List<String> fittingsList = [];

  Future<void> setLoadCircularSetCards(bool value) async {
    loadCircularSetCards = value;
  }

  @action
  setInfo() async =>
      info = await FirebaseFirestore.instance.collection('info').get();
  @action
  setSpecName(String spc) => specName = spc;
  @action
  setSpecID(String iD) => specialityID = iD;
  @action
  setShowNav(bool shw) => showNavigator = shw;
  @action
  setSelectedTrunk(int value) => selectedTrunk = value;
  @action
  setNoHistoric(bool value) => noHistoric = value;
  @action
  setDoctorId(String _doctorId) => doctorId = _doctorId;

  @action
  logout() async {
    await setTokenLogout();
    userConnected(false);
    authStore.signout();
    rootStore.selectedTrunk = 1;
    authStore.user = null;
    Fluttertoast.showToast(msg: "Você foi bloqueado(a)");
    Modular.to.pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
  }

  Future<void> setTokenLogout() async {
    String token = await FirebaseMessaging.instance.getToken();
    print('user token: $token');
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();

    List tokens = _user['token_id'];
    print('tokens length: ${tokens.length}');

    for (var i = 0; i < tokens.length; i++) {
      if (tokens[i] == token) {
        print('has $token');
        tokens.removeAt(i);
        print('tokens: $tokens');
      }
    }
    print('tokens2: $tokens');
    _user.reference.update({'token_id': tokens});
  }

  Future<void> userConnected(bool connected) async {
    if (authStore.user != null) {
      DocumentSnapshot _user = await FirebaseFirestore.instance
          .collection('patients')
          .doc(authStore.user.uid)
          .get();

      _user.reference.update({'connected': connected});
    }
  }

  @action
  Future<bool> getCards() async {
    QuerySnapshot cards = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .collection('cards')
        .where('status', isEqualTo: 'ACTIVE')
        .get();

    return cards.docs.isNotEmpty;
  }

  @action
  answerRating() async {
    DocumentSnapshot docAppointment = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentIdRating)
        .get();

    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();

    await docAppointment.reference.update({'rated': true});

    _user.reference
        .collection('appointments')
        .doc(appointmentIdRating)
        .update({'rated': true});

    DocumentSnapshot doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorIdRating)
        .get();

    int newRatings =
        doctor['new_ratings'] != null ? doctor['new_ratings'] + 1 : 1;

    doctor.reference.update({'new_ratings': newRatings});

    QuerySnapshot secretaries = await doctor.reference
        .collection('secretaries')
        .where('status', isEqualTo: 'ACCEPTED')
        .get();

    secretaries.docs.forEach((secretaryRef) async {
      DocumentSnapshot secretaryDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(secretaryRef.id)
          .get();

      int newRatingsSec = secretaryDoc['new_ratings'] != null
          ? secretaryDoc['new_ratings'] + 1
          : 1;

      secretaryDoc.reference.update({'new_ratings': newRatingsSec});
    });

    DocumentReference rating =
        await FirebaseFirestore.instance.collection('ratings').add({
      'created_at': FieldValue.serverTimestamp(),
      'avaliation': valueRating,
      'photo': _user['avatar'],
      'text': textRating != null ? textRating : '',
      'patient_id': authStore.user.uid,
      'username': _user['username'],
      'appointment_id': appointmentIdRating,
      'doctor_id': doctorIdRating,
      'status': 'VISIBLE',
    });

    rating.update({'id': rating.id});

    doctor.reference.collection('ratings').doc(rating.id).set({
      'created_at': FieldValue.serverTimestamp(),
      'avaliation': valueRating,
      'photo': _user['avatar'],
      'text': textRating != null ? textRating : '',
      'patient_id': authStore.user.uid,
      'username': _user['username'],
      'appointment_id': appointmentIdRating,
      'status': 'VISIBLE',
      'id': rating.id,
    });

    HttpsCallable messageNotification =
        FirebaseFunctions.instance.httpsCallable('evaluate');
    String _drId = doctor.id;
    String _text =
        'O paciente ${_user['username']} acabou de te avaliar com $valueRating estrelas!';
    print('text $_text');
    print('drId $_drId');
    try {
      print('no try');
      messageNotification.call({
        'text': _text,
        'senderId': authStore.user.uid,
        'receiverId': _drId,
        'receiverCollection': 'doctors',
      });
      print('Notificação enviada');
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

    textRating = null;
    popUpRating = false;
  }

  @action
  Future<Map> answerFit(bool confirm, String appointmentIdFit,
      {Function callBack}) async {
    // try {} catch (e) {}

    DocumentSnapshot patient = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();

    DocumentSnapshot docAppointment = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentIdFit)
        .get();

    DocumentSnapshot patientAppointment = await patient.reference
        .collection('appointments')
        .doc(appointmentIdFit)
        .get();

    DocumentSnapshot doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(docAppointment['doctor_id'])
        .get();

    print('xxxxxxxxxxxxxxxxxxxxxxxxxx confirm $confirm   xxxxxxxxxxxxxxxxxxxx');

    if (confirm) {
      if (await getCards() == false) {
        setCards = true;

        return {
          'status': 'FAILED',
          'code': 'dont-has-card',
        };
      } else {
        print('xxxxxxxxxxxx functions xxxxxxxxxxxxxxx');
        FirebaseFunctions functions = FirebaseFunctions.instance;
        // functions.useFunctionsEmulator('localhost', 5001);
        HttpsCallable callableSecurityDeposit =
            functions.httpsCallable('securityDeposit');
        String strPercent =
            (docAppointment.get('price') * 0.3).toStringAsFixed(2);
        num percent = double.parse(strPercent);

        HttpsCallableResult<String> error = await callableSecurityDeposit.call({
          'patientId': authStore.user.uid,
          'price': percent,
          'appointmentId': docAppointment.id,
          'doctorId': docAppointment['doctor_id'],
          'remaining': false,
        });
        if (error.data != null) {
          flutterToast('Não foi possível realizar o pagamento.');
          return {
            'status': 'FAILED',
            'code': 'payment-failed',
          };
        } else {
          await docAppointment.reference.update({'status': 'SCHEDULED'});
          await patientAppointment.reference.update({'status': 'SCHEDULED'});

          DocumentSnapshot doctorSchedule = await doctor.reference
              .collection('schedules')
              .doc(docAppointment['schedule_id'])
              .get();

          DocumentSnapshot docSchedule = await FirebaseFirestore.instance
              .collection('schedules')
              .doc(docAppointment['schedule_id'])
              .get();

          await doctorSchedule.reference.update({
            'occupied_vacancies': doctorSchedule['occupied_vacancies'] + 1,
          });

          await docSchedule.reference.update({
            'occupied_vacancies': docSchedule['occupied_vacancies'] + 1,
          });

          selectedTrunk = 2;

          HttpsCallable callable =
              FirebaseFunctions.instance.httpsCallable('answerNotification');
          DateTime afterAppointment =
              appointment.hour.toDate().subtract(Duration(hours: 2));
          Timestamp afterHour = Timestamp.fromDate(afterAppointment);
          int seconds = afterHour.seconds;

          int nanoseconds = afterHour.nanoseconds;
          try {
            callable.call(<String, dynamic>{
              'senderId': appointment.patientId,
              'receiverId': appointment.doctorId,
              'confirm': confirm,
              'seconds': seconds,
              'nanoseconds': nanoseconds,
              'hourString': TimeModel().hour(appointment.hour),
              'appointmentId': appointment.id,
            });
            fittingsList.remove(docAppointment.id);

            return {
              'status': 'SUCCESS',
              'code': null,
            };
          } on FirebaseFunctionsException catch (e) {
            print('caught firebase functions exception');
            print(e);
            print(e.code);
            print(e.message);
            print(e.details);
            fittingsList.remove(docAppointment.id);

            return {
              'status': 'SUCCESS',
              'code': 'error-only-functions',
            };
          }
        }
      }
    } else {
      await docAppointment.reference.update({'status': 'REFUSED'});
      await patientAppointment.reference.update({'status': 'REFUSED'});

      // appointmentIdFit = '';

      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('answerNotification');
      DateTime afterAppointment =
          appointment.hour.toDate().subtract(Duration(hours: 2));
      Timestamp afterHour = Timestamp.fromDate(afterAppointment);
      int seconds = afterHour.seconds;

      int nanoseconds = afterHour.nanoseconds;
      try {
        callable.call(<String, dynamic>{
          'senderId': appointment.patientId,
          'receiverId': appointment.doctorId,
          'confirm': confirm,
          'seconds': seconds,
          'nanoseconds': nanoseconds,
          'hourString': TimeModel().hour(appointment.hour),
          'appointmentId': appointment.id,
        });

        fittingsList.remove(docAppointment.id);

        return {
          'status': 'SUCCESS',
          'code': null,
        };
      } on FirebaseFunctionsException catch (e) {
        print('caught firebase functions exception');
        print(e);
        print(e.code);
        print(e.message);
        print(e.details);
        fittingsList.remove(docAppointment.id);

        return {
          'status': 'SUCCESS',
          'code': 'error-only-notifications',
        };
      }
    }
  }

  @action
  popUpRate(docAppointment) async {
    doctorIdRating = docAppointment['doctor_id'];
    appointmentIdRating = docAppointment.id;
    DocumentSnapshot docDoctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(docAppointment['doctor_id'])
        .get();

    doctorName = docDoctor['fullname'] != null
        ? docDoctor['fullname']
        : docDoctor['username'];

    doctorPhoto = docDoctor['avatar'];

    popUpRating = true;
  }

  @action
  popUpFit(docAppointment, BuildContext context) async {
    String text = ' está tentando te encaixar em uma consulta com ele, no dia ';

    DateTime date = docAppointment['hour'].toDate();

    if (docAppointment['dependent_id'] != null) {
      DocumentSnapshot patient = await FirebaseFirestore.instance
          .collection('patients')
          .doc(docAppointment['dependent_id'])
          .get();

      text =
          ' está tentando encaixar ${patient['fullname']} em uma consulta, no dia ';
    }

    DocumentSnapshot docDoctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(docAppointment['doctor_id'])
        .get();

    String name = docDoctor['fullname'] != null
        ? docDoctor['fullname']
        : docDoctor['username'];

    String doctorName = 'Dr(a). ' + name;

    String stringDate = date.day.toString().padLeft(2, '0') +
        '/' +
        date.month.toString().padLeft(2, '0') +
        ' às ' +
        date.hour.toString().padLeft(2, '0') +
        ':' +
        date.minute.toString().padLeft(2, '0');

    String price = 'R\$' + formatedCurrency(docAppointment['price']);

    String textFit = doctorName +
        text +
        stringDate +
        '. O preço desta consulta é de $price.';

    appointment = AppointmentModel.fromDocumentSnapshot(docAppointment);

    String appointmentIdFit = docAppointment.id;

    OverlayEntry fitRequestedPopUp;
    fitRequestedPopUp = OverlayEntry(
      builder: (context) {
        return FitRequestedDialog(
          onConfirm: () async {
            Map response = await answerFit(true, appointmentIdFit);
            print('zzzzzzzzzzZZZZZZZzZZZZ onConfirm $response');
            print(
                'zzzzzzzzzzZZZZZZZzZZZZ onConfirm statsu ${response['status']}');
            if (response['status'] == 'SUCCESS') {
              fitRequestedPopUp.remove();
              fitRequestedPopUp = null;
            }
          },
          onCancel: () async {
            Map response = await answerFit(false, appointmentIdFit);
            print('zzzzzzzzzzZZZZZZZzZZZZ onConfirm $response');
            print(
                'zzzzzzzzzzZZZZZZZzZZZZ onConfirm status ${response['status']}');
            if (response['status'] == 'SUCCESS') {
              fitRequestedPopUp.remove();
              fitRequestedPopUp = null;
            }
          },
          text: textFit,
        );
      },
    );

    Overlay.of(context).insert(fitRequestedPopUp);
  }

  Future<void> rescheduleAccept() async {
    loadCircularReschedule = true;

    DocumentSnapshot appointmentDoc = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(rescheduleId)
        .get();

    if (appointmentDoc['type'] == 'RETURN') {
      DocumentSnapshot _returnAppointment = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentDoc['appointment_id'])
          .get();

      appointmentReturn =
          AppointmentModel.fromDocumentSnapshot(_returnAppointment);
      returning = true;
    }

    appointmentReschedule =
        AppointmentModel.fromDocumentSnapshot(appointmentDoc);
    reschedule = true;

    setDoctorId(appointmentDoc['doctor_id']);

    // await appointmentDoc.reference.update({"canceled_by_doctor": false});

    await FirebaseFirestore.instance
        .collection('patients/${authStore.user.uid}/appointments')
        .doc(appointmentDoc.id)
        .update({'canceled_by_doctor': false});
    loadCircularReschedule = false;
    await Modular.to.pushNamed(
      '/schedule',
      arguments: true,
    );
  }

  Future<void> rescheduleRefused() async {
    loadCircularReschedule = true;

    DocumentSnapshot appointmentDoc = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(rescheduleId)
        .get();

    appointmentDoc.reference.update({"canceled_by_doctor": false});

    await FirebaseFirestore.instance
        .collection('patients/${authStore.user.uid}/appointments')
        .doc(appointmentDoc.id)
        .update({'canceled_by_doctor': false});

    loadCircularReschedule = false;
    rescheduleId = null;
    popUpRescheduleRequest = false;
  }

  Future<void> getPopUpReschedule(DocumentSnapshot appointmentDoc) async {
    DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(appointmentDoc['doctor_id'])
        .get();

    String doctorName = doctorDoc['username'];

    Timestamp appointmentTimestamp = appointmentDoc['date'];

    DateTime appointmentDate = appointmentTimestamp.toDate();

    String date = appointmentDate.day.toString().padLeft(2, '0') +
        '/' +
        appointmentDate.month.toString().padLeft(2, '0') +
        ' às ' +
        appointmentDate.hour.toString().padLeft(2, '0') +
        ':' +
        appointmentDate.minute.toString().padLeft(2, '0');

    textPopUpReschedule =
        'O(a) especialista $doctorName teve que cancelar a consulta do dia $date. Deseja remarcar uma consulta?';

    rescheduleId = appointmentDoc.id;
    popUpRescheduleRequest = true;
  }

  void getPopUps(BuildContext context) async {
    print(
        'xxxxxxx getPopUps ${authStore.user != null} ${authStore.user.uid} xxxxxxx');
    if (authStore.user != null) {
      DocumentSnapshot _patient = await FirebaseFirestore.instance
          .collection('patients')
          .doc(authStore.user.uid)
          .get();

      Stream<DocumentSnapshot> _patSnap = _patient.reference.snapshots();

      _patSnap.listen((DocumentSnapshot event) {
        // print("Eveeent: ${event['status']}");
        if (event['status'] == "BLOCKED") {
          // print("Eveeent: ${event['status']}");
          logout();
        }
      });

      Stream<QuerySnapshot<Map<String, dynamic>>> streamAppointments =
          _patient.reference.collection('appointments').snapshots();

      streamAppointments.listen((QuerySnapshot appointmentsQuery) async {
        int count = appointmentsQuery.docs.length;

        print(
            'xxxxxxxxxxXXXXXXXXXXXXXXXXXXXXXXXX listen $count XXXXXXXXXXXXXXXXXXXXXXXxxxxxxxxxxxx');
        for (int i = 0; i < count; i++) {
          DocumentSnapshot docAppointment = appointmentsQuery.docs[i];

          if (docAppointment['status'] == 'FIT_REQUESTED') {
            print(
                'xxxxxxxxxx for ${docAppointment['status']} - ${docAppointment.id} - ${fittingsList.contains(docAppointment.id)} xxxxxxxxxxxx');
            if (!fittingsList.contains(docAppointment.id)) {
              fittingsList.add(docAppointment.id);
              await popUpFit(docAppointment, context);
            }

            break;
          }

          if (docAppointment['status'] == 'CANCELED' &&
              docAppointment['canceled_by_doctor']) {
            await getPopUpReschedule(docAppointment);

            break;
          }

          if (docAppointment['status'] == 'CONCLUDED' ||
              docAppointment['status'] == 'AWAITING_RETURN') {
            // print('xxxxxxxxxx rated ${docAppointment['rated']} xxxxxxxxxxxx');

            if (!docAppointment['rated']) {
              await popUpRate(docAppointment);

              break;
            }
          }
        }
        print('FIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIM listen');
      });
    }
    print('FIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIM');
  }

  getUser() async {
    print('AAAAAAAAAAAAAAAAAAAMTES: ${authStore.user.uid}');
    Stream<DocumentSnapshot> userDoc = FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .snapshots();
    print('DEEEEEEEEEEEEEEEEEEEEEPPOIS: $userDoc');

    userDoc.listen((event) {
      print('eventeventeventeventevent: $event');

      userSnap = event;
    });
  }

  bool getSupport() {
    bool aux = false;
    supportStream = FirebaseFirestore.instance
        .collection('support')
        .where('patient_id', isEqualTo: authStore.user.uid)
        .snapshots();

    supportStream.listen((event) {
      if (event.docs.isNotEmpty) {
        support = event;
        supportId = support.docs.first.id;
        aux = true;
      }
    });
    return aux;
  }

  setSupportChat() async {
    String avatar;

    support = await FirebaseFirestore.instance
        .collection('support')
        .where('patient_id', isEqualTo: authStore.user.uid)
        .get();

    avatar = userSnap.get('avatar');

    if (avatar == null) {
      avatar =
          'https://firebasestorage.googleapis.com/v0/b/encontrarCuidado-project.appspot.com/o/settings%2FuserDefaut.png?alt=media&token=4c4aa544-555a-4c1d-bef1-0b61a1e2dc10';
    }

    if (support.docs.isEmpty) {
      DocumentReference supportRef =
          await FirebaseFirestore.instance.collection('support').add({
        'created_at': FieldValue.serverTimestamp(),
        'patient_id': authStore.user.uid,
        'doctor_id': null,
        'user_avatar': avatar,
        'support_avatar': avatar,
        'usr_notifications': 0,
        'sp_notifications': 0,
        'updated_at': FieldValue.serverTimestamp(),
      });
      await supportRef.update({'id': supportRef.id});
      supportId = supportRef.id;
    } else {
      supportId = support.docs.first.id;
    }
    // clickSupport = false;
  }

  @action
  nullSpec() async {
    QuerySnapshot nullS = await FirebaseFirestore.instance
        .collection('specialties')
        .where('speciality', isEqualTo: 'Médico')
        .get();

    nullSpeciality = nullS.docs.first.get('id');
  }

  Future<void> hasChatWith(String drID) async {
    doctorID = drID;
    QuerySnapshot chat = await FirebaseFirestore.instance
        .collection('chats')
        .where('patient_id', isEqualTo: authStore.user.uid)
        .where('doctor_id', isEqualTo: drID)
        .get();

    DocumentSnapshot dr =
        await FirebaseFirestore.instance.collection('doctors').doc(drID).get();

    drAvatar = dr.get('avatar');

    chatName = dr.get('username');
    hasChat = chat.docs.isNotEmpty;

    if (chat.docs.isNotEmpty) {
      profileChat = chat.docs.first;
    } else {
      profileChat = null;
    }
  }

  String getVisitType(String type) {
    switch (type) {
      case "FIT":
        return "Encaixe de paciente";
        break;
      case "SCHEDULE":
        return "Consulta médica";
        break;
      case "RETURN":
        return "Retorno";
        break;
      case "RESQUEDULE":
        return "Reagendamento";
        break;
      default:
        return "Não informado";
    }
  }
}
