import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'widgets/confirm_card.dart';
import 'widgets/email_dialog.dart';
part 'payment_store.g.dart';

class PaymentStore = _PaymentStoreBase with _$PaymentStore;

abstract class _PaymentStoreBase with Store {
  final AuthStore authStore = Modular.get();
  final MainStore mainStore = Modular.get();

  @observable
  List cardsList;
  @observable
  List transactionsList;
  @observable
  Map<String, dynamic> cardMap = Map();
  @observable
  ObservableMap focusNodeMap = ObservableMap();
  @observable
  bool input = false,
      inputState = false,
      inputCity = false,
      refundCircular = false;
  @observable
  List listCitys = [], listStates = [];
  @observable
  List newListCitys = [], newListStates = [];
  @observable
  TextEditingController textEditingControllerState = TextEditingController();
  @observable
  TextEditingController textEditingControllerCity = TextEditingController();
  @observable
  int hexDec = (Random().nextDouble() * 0xffffffff).toInt() << 0,
      hexDec2 = (Random().nextDouble() * 0xffffffff).toInt() << 0;
  @observable
  bool removingCard = false;
  @observable
  String refundNote = '';
  @observable
  bool canRefund = false;
  @observable
  bool loadCircularEmailDialog = false;
  @observable
  bool hasValidEmail = false;
  @observable
  Timer _timer;
  @observable
  OverlayEntry addCardOverlay;
  @observable
  OverlayEntry loadOverlay;
  @observable
  OverlayEntry emailOverlay;

  @action
  setRefundNote(String n) => refundNote = n;

  void onBack() {
    cardMap = Map();

    textEditingControllerCity.clear();
    textEditingControllerState.clear();

    listCitys = [];
    newListCitys = [];
    newListStates = [];

    input = false;
  }

  Future<bool> isSingleCard() async {
    QuerySnapshot cardsQuery = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .collection('cards')
        .where('status', isEqualTo: 'ACTIVE')
        .get();

    return cardsQuery.docs.length > 1;
  }

  Future<void> cancelConsulation(String appointmentId) async {
    DocumentSnapshot appointmentDoc = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .get();

    DocumentSnapshot patientAppointmentDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .collection('appointments')
        .doc(appointmentId)
        .get();

    DocumentSnapshot doctorScheduleDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(appointmentDoc['doctor_id'])
        .collection('schedules')
        .doc(appointmentDoc['schedule_id'])
        .get();

    DocumentSnapshot scheduleDoc = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(appointmentDoc['schedule_id'])
        .get();

    await doctorScheduleDoc.reference.update({
      'occupied_vacancies': (doctorScheduleDoc['occupied_vacancies'] - 1),
    });

    await scheduleDoc.reference.update({
      'occupied_vacancies': (scheduleDoc['occupied_vacancies'] - 1),
    });

    if (appointmentDoc['type'] != 'FIT') {
      await doctorScheduleDoc.reference.update({
        'available_vacancies': (doctorScheduleDoc['available_vacancies'] + 1),
      });
      await scheduleDoc.reference.update({
        'available_vacancies': (scheduleDoc['available_vacancies'] + 1),
      });
    }

    print('cancelConsulationcancelConsulationcancelConsulation $appointmentId');

    await appointmentDoc.reference.update({'status': 'CANCELED'});
    await patientAppointmentDoc.reference.update({'status': 'CANCELED'});
  }

  @action
  Future<void> getTimestamp() async {
    QuerySnapshot infoQuery =
        await FirebaseFirestore.instance.collection('info').get();

    DocumentSnapshot infoDoc = infoQuery.docs.first;

    await infoDoc.reference.update({'timestamp': FieldValue.serverTimestamp()});
  }

  void getCanRefound(String id) async {
    DocumentSnapshot transactionDoc = await FirebaseFirestore.instance
        .collection('transactions')
        .doc(id)
        .get();

    print('xxxxxxxx getCanRefound ${transactionDoc['status']}');

    canRefund = transactionDoc['status'] != 'REFUND' &&
        transactionDoc['status'] != 'REFUND_REQUESTED_INCOME' &&
        transactionDoc['status'] != 'PENDING_REFUND';
    print('%%%%%%%%% $canRefund %%%%%%%%%');
  }

  @action
  Future<String> requestRefund(String transactionId, String drID) async {
    refundCircular = true;
    String status = '';

    await getTimestamp();

    DocumentSnapshot transactionDoc = await FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionId)
        .get();

    DocumentSnapshot drDoc =
        await FirebaseFirestore.instance.collection('doctors').doc(drID).get();

    DocumentSnapshot drTransactionDoc = await drDoc.reference
        .collection('transactions')
        .doc(transactionId)
        .get();

    DocumentSnapshot ptDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(mainStore.authStore.user.uid)
        .get();

    DocumentSnapshot ptTransactionDoc = await ptDoc.reference
        .collection('transactions')
        .doc(transactionId)
        .get();

    DocumentSnapshot appointmentDoc = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(transactionDoc['appointment_id'])
        .get();

    try {
      if (transactionDoc['type'] == 'GUARANTEE') {
        QuerySnapshot infoQuery =
            await FirebaseFirestore.instance.collection('info').get();

        DocumentSnapshot infoDoc = infoQuery.docs.first;

        DateTime nowDate = infoDoc['timestamp'].toDate();

        DateTime appointmentDate = appointmentDoc['hour'].toDate();

        print(
            '%%%%%%%%%%%%%% ahhhhhhh ${nowDate.difference(appointmentDate).inDays} $nowDate - $appointmentDate %%%%%%%%%%%%%%');

        if (nowDate.difference(appointmentDate).inDays <= -2) {
          print('%%%%%%%%% menoor %%%%%%%%%');
          await transactionDoc.reference.update({
            'status': 'PENDING_REFUND',
          });

          await ptTransactionDoc.reference.update({
            'status': 'PENDING_REFUND',
          });

          await drTransactionDoc.reference.update({
            'status': 'PENDING_REFUND',
          });
          print("#@#@#@#@#@# reembolsando diretamente #@#@#@#@#@#");

          await callFunction("notifyUser", {
            "text": "O paciente ${ptDoc.get("username")} reembolsou a caução",
            "senderId": ptDoc.id,
            "receiverId": drDoc.id,
            "collection": "doctors",
          });

          status = 'PENDING_REFUND';
          await cancelConsulation(transactionDoc['appointment_id']);
        } else {
          print("#@#@#@#@#@# reembolso da caução solicitado #@#@#@#@#@#");
          await callFunction("notifyUser", {
            "text":
                "O paciente ${ptDoc.get("username")} solicitou reembolso da caução de código ${appointmentDoc.id.substring(appointmentDoc.id.length - 4, appointmentDoc.id.length).toUpperCase()}",
            "senderId": ptDoc.id,
            "receiverId": drDoc.id,
            "collection": "doctors",
          });
          status = 'REFUND_REQUESTED_INCOME';
        }
      } else {
        print("#@#@#@#@#@# reembolso de remanescente solicitado #@#@#@#@#@#");
        await callFunction("notifyUser", {
          "text":
              "O paciente ${ptDoc.get("username")} solicitou reembolso do remanescente de código ${appointmentDoc.id.substring(appointmentDoc.id.length - 4, appointmentDoc.id.length).toUpperCase()}",
          "senderId": ptDoc.id,
          "receiverId": drDoc.id,
          "collection": "doctors",
        });
        status = 'REFUND_REQUESTED_INCOME';
      }

      await transactionDoc.reference.update({
        'status': status,
        'note': refundNote,
        'updated_at': FieldValue.serverTimestamp(),
      });

      await drTransactionDoc.reference.update({
        'status': status,
        'note': refundNote,
        'updated_at': FieldValue.serverTimestamp(),
      });

      await ptTransactionDoc.reference.update({
        'status': status,
        'note': refundNote,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erooooo: $e');
      print('Eroooooooror: ${e.toString()}');
    }

    refundCircular = false;
    return status;
  }

  void getCards(QuerySnapshot cardsQuery) {
    if (cardsQuery.docs.isNotEmpty) {
      cardsList = cardsQuery.docs.toList();
    } else {
      cardsList = [];
    }
  }

  void getTransactions(QuerySnapshot transactionsQuery) {
    if (transactionsQuery.docs.isNotEmpty) {
      transactionsList = transactionsQuery.docs.toList();
    } else {
      transactionsList = [];
    }
  }

  String getDate(Timestamp date) {
    List monthList = [
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
      'Dezembro'
    ];
    if (date != null) {
      DateTime dateTime = date.toDate();

      String day = dateTime.day.toString().padLeft(2, '0');

      String month = monthList[dateTime.month];

      if (month.length > 5) {
        month = month.substring(0, 3);
      }
      return '$day de $month';
    } else {
      return 'dia da consulta';
    }
  }

  void changedMain(String cardId, bool value) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;
    // functions.useFunctionsEmulator('localhost', 5001);
    HttpsCallable callable = functions.httpsCallable('changingCardToMain');
    try {
      await callable.call({
        "cardId": cardId,
        "userId": authStore.user.uid,
        "main": value,
        "userCollection": "patients",
      });
    } on FirebaseFunctionsException catch (e) {
      print('xxxxxxxxxxxx Não deu certo xxxxxxxxxxxxxxx');
      print('ERROR: $e');
    }
  }

  removeCard(String cardId) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;
    // functions.useFunctionsEmulator('localhost', 5001);
    HttpsCallable callable = functions.httpsCallable('deleteCard');
    try {
      await callable.call({
        "cardId": cardId,
        "userId": authStore.user.uid,
        "userCollection": "patients",
      });
    } on FirebaseFunctionsException catch (e) {
      print('xxxxxxxxxxxx Não deu certo xxxxxxxxxxxxxxx');
      print('ERROR: $e');
    }

    removingCard = false;

    Modular.to.pop();
  }

  Future<void> pushProfile() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("patients")
        .doc(mainStore.authStore.user.uid)
        .get();
    PatientModel patientModel = PatientModel.fromDocument(userDoc);
    loadCircularEmailDialog = false;
    if (emailOverlay != null && emailOverlay.mounted) {
      emailOverlay.remove();
    }
    Modular.to.pushNamed('/payment/edit-profile', arguments: patientModel);
  }

  Future<int> hasEmail() async {
    User _user = FirebaseAuth.instance.currentUser;
    bool emailVerified = false;
    int returnIndex = 0;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(_user.uid)
        .get();

    print('xxxxxxxxxxxx hasEmail ${userDoc['email']} xxxxxxxxxxxxxxx');

    if (userDoc['email'] != null) {
      emailVerified = _user.emailVerified;
      print('xxxxxxxxxxxx hasEmail $emailVerified xxxxxxxxxxxxxxx');

      if (!emailVerified) {
        returnIndex = 1;
        // Tem email, mas não foi validado.
      }
    } else {
      returnIndex = 2;
      // ainda não tem email.
    }
    return returnIndex;
  }

  Future<void> saveCard(Function callBack, context) async {
    print('xxxxxxxxxxxx onTapp xxxxxxxxxxxxxxx');
    int index = await hasEmail();

    if (index == 0) {
      callBack();

      addCardOverlay = OverlayEntry(
        builder: (context) => ConfirmCard(
          svgWay: 'assets/svg/confirmaddcard.svg',
          text: 'Tem certeza que deseja adicionar \nesse cartão?',
          onBack: () {
            addCardOverlay.remove();
          },
          onConfirm: () async {
            loadOverlay =
                OverlayEntry(builder: (context) => LoadCircularOverlay());
            Overlay.of(context).insert(loadOverlay);

            // user create stripe customer, after create card in stripe.
            User _user = FirebaseAuth.instance.currentUser;
            FirebaseFunctions functions = FirebaseFunctions.instance;
            // functions.useFunctionsEmulator('localhost', 5001);
            HttpsCallable callable =
                functions.httpsCallable('createStripeCustomer');
            // try {
            print('main ${cardMap['main']}');
            if (cardMap['main'] == null) {
              cardMap['main'] = false;
            }

            HttpsCallableResult<String> hasError = await callable.call({
              "uid": _user.uid,
              "email": _user.email,
              "card": cardMap,
              "userCollection": "patients",
            });
            print('xxxxxxxxxxxxxxxxxxxxx hasError ${hasError.data}');

            if (hasError.data != '') {
              String text;
              switch (hasError.data) {
                case 'incorrect_number':
                  text = 'Número de cartão inválido!';
                  break;

                case 'card_declined':
                  text = 'Cartão recusado!';
                  break;

                case 'expired_card':
                  text = 'Cartão expirado!';
                  break;

                case 'invalid_expiry_year':
                  text = 'Cartão expirado!';
                  break;

                case 'incorrect_cvc':
                  text = 'Código de segurança inválido!';
                  break;

                case 'processing_error':
                  text = 'Erro ao criar cartão!';
                  break;

                default:
                  text = 'Erro ao criar cartão!';
                  break;
              }
              flutterToast(text, true);
              loadOverlay.remove();
              addCardOverlay.remove();
            } else {
              onBack();
              Modular.to.pop();
              loadOverlay.remove();
              addCardOverlay.remove();
            }
          },
        ),
      );
      Overlay.of(context).insert(addCardOverlay);
    } else {
      print('xxxxxxxxxxxx Não tem email xxxxxxxxxxxxxxx');
      hasValidEmail = index == 1 ? true : false;

      emailOverlay = OverlayEntry(
        builder: (context) => EmailDialog(
          onCancel: () {
            emailOverlay.remove();
          },
          title: 'Você não possui um e-mail válido ainda.',
        ),
      );

      Overlay.of(context).insert(emailOverlay);
      callBack();
    }
  }

  Future<void> getValidEmail() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      User _user = FirebaseAuth.instance.currentUser;
      if (_user != null) {
        await _user.reload();

        if (_user.emailVerified) {
          flutterToast('O seu e-mail foi validado!');
          if (emailOverlay != null && emailOverlay.mounted) {
            emailOverlay.remove();
          }
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
    return null;
  }

  Future<void> validateEmail() async {
    User _user = FirebaseAuth.instance.currentUser;
    await _user.reload();
    if (_user.emailVerified) {
      flutterToast('O seu e-mail já foi validado!');
      loadCircularEmailDialog = false;
      if (emailOverlay != null && emailOverlay.mounted) {
        emailOverlay.remove();
      }
    } else {
      try {
        await authStore.user.sendEmailVerification();
        if (_timer == null || !_timer.isActive) {
          getValidEmail();
        }
        flutterToast('Link enviado com sucesso!');
        loadCircularEmailDialog = false;
      } catch (e) {
        print('$e');

        flutterToast(
            'Espere alguns minutos para poder enviar outro email de verificação');
        loadCircularEmailDialog = false;
      }
    }
  }

  void getColors() {
    hexDec = (Random().nextDouble() * 0xffffffff).toInt() << 0;
    hexDec2 = (Random().nextDouble() * 0xffffffff).toInt() << 0;
  }

  Future<void> getCitys() async {
    QuerySnapshot info =
        await FirebaseFirestore.instance.collection('info').get();

    DocumentSnapshot docInfo = info.docs.first;
    QuerySnapshot states = await docInfo.reference.collection('states').get();

    states.docs.forEach((DocumentSnapshot state) {
      if (state['name'] == cardMap['billing_state']) {
        listCitys = state['citys'];
      }
    });
  }

  void filterListCity(String text) {
    List newList = [];

    if (text != '') {
      listCitys.forEach((city) {
        if (!newList.contains(city) && city.toLowerCase().contains(text)) {
          newList.add(city);
        }
      });

      newListCitys = newList;
    } else {
      newListCitys = [];
    }
  }

  void filterListState(String textState) {
    List newList = [];
    if (textState != '') {
      listStates.forEach((state) {
        if (!newList.contains(state) &&
            state.toLowerCase().contains(textState)) {
          newList.add(state);
        }
      });
      newListStates = newList;
    } else {
      newListStates = [];
    }
  }

  void getStates() async {
    List list = [];
    QuerySnapshot info =
        await FirebaseFirestore.instance.collection('info').get();

    DocumentSnapshot docInfo = info.docs.first;
    QuerySnapshot states = await docInfo.reference.collection('states').get();

    states.docs.forEach((DocumentSnapshot state) {
      list.add(state['name'] + ' - ' + state['acronyms']);
    });
    listStates = list;
  }

  void flutterToast(String text, [bool alert = false]) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: alert ? Colors.red : Color(0xff41C3B3),
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
