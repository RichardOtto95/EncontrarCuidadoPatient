import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:encontrarCuidado/app/modules/profile/widgets/confirm_profile_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'widgets/confirm_code.dart';
part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;

abstract class _ProfileStoreBase with Store {
  final AuthStore authStore = Modular.get();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @observable
  bool genderDialog = false;
  @observable
  int listGenderIndex = 0;
  @observable
  bool loadCircularAvatar = false;
  @observable
  FocusNode focusNodeState;
  @observable
  FocusNode focusNodeCity;
  @observable
  bool dateError = false;
  @observable
  bool genderError = false;
  @observable
  bool avatarError = false;
  @observable
  bool validEdit = false;
  @observable
  bool input = false;
  @observable
  ObservableMap<String, dynamic> mapPatient = ObservableMap();
  @observable
  TextEditingController textEditingControllerCity = TextEditingController(),
      textEditingControllerState = TextEditingController();
  @observable
  OverlayEntry confirmEditOverlay;
  @observable
  List listCitys = [], listStates = [];
  @observable
  List newListCitys = [], newListStates = [];
  @observable
  List addressKeys = [];
  @observable
  DocumentSnapshot supportDoc;
  @observable
  QuerySnapshot messagesDocs;
  @observable
  ObservableList chat = [].asObservable();
  @observable
  bool logout = false;
  @observable
  Timer _timer;
  @observable
  String code = '';
  @observable
  bool loadCircularCode = false, loadCircularEdit = false;
  @observable
  String userVerificationId;
  @observable
  String oldEmail;
  @observable
  OverlayEntry confirmCodeOverlay;
  @observable
  int forceResendingToken;
  @observable
  Timer timerResendeCode;
  @observable
  int timerSeconds;
  @observable
  String email;

  void backNotifications() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();

    userDoc.reference.update({'new_notifications': 0});

    QuerySnapshot notificationsQuery = await userDoc.reference
        .collection('notifications')
        .where('viewed', isEqualTo: false)
        .get();

    notificationsQuery.docs.forEach((DocumentSnapshot notificationDoc) {
      notificationDoc.reference.update({'viewed': true});
    });
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

  void clearNewNotifications() {
    FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get()
        .then((DocumentSnapshot patientDoc) =>
            patientDoc.reference.update({'new_notifications': 0}));
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

  @action
  getSuportChat(String id) async {
    supportDoc =
        await FirebaseFirestore.instance.collection('support').doc(id).get();

    messagesDocs = await supportDoc.reference.collection('messages').get();

    Stream<QuerySnapshot> msgs = FirebaseFirestore.instance
        .collection('support')
        .doc(id)
        .collection('messages')
        .orderBy('created_at', descending: false)
        .snapshots();
    msgs.listen((event) {
      event.docs.forEach((element) {
        chat.add(element);
      });
    });
  }

  @action
  setAddressKeys() async {
    if (mapPatient['state'] != null) {
      QuerySnapshot aux =
          await FirebaseFirestore.instance.collection('info').get();

      QuerySnapshot states = await aux.docs.first.reference
          .collection('states')
          .where('name', isEqualTo: mapPatient['state'])
          .get();
      DocumentSnapshot state = states.docs.first;
      if (state != null) {
        for (var i = 0; i < state.get('name').length; ++i) {
          addressKeys.add(state.get('name').substring(0, i + 1).toUpperCase());
        }
      }
    }
    if (mapPatient['city'] != null) {
      for (var ii = 0; ii < mapPatient['city'].length; ++ii) {
        addressKeys.add(mapPatient['city'].substring(0, ii + 1).toUpperCase());
      }
    }
  }

  @action
  filterListCity(String text) {
    List newList = [];
    if (text != '') {
      listCitys.forEach((city) {
        if (!newList.contains(city) && city.toLowerCase().contains(text)) {
          newList.add(city);
        }
        newListCitys = newList;
      });
    } else {
      newListCitys = [];
    }
  }

  @action
  getCitys() async {
    QuerySnapshot aux =
        await FirebaseFirestore.instance.collection('info').get();

    QuerySnapshot states =
        await aux.docs.first.reference.collection('states').get();

    states.docs.forEach((DocumentSnapshot state) {
      if (state['name'] == mapPatient['state']) {
        listCitys = state['citys'];
      }
    });
  }

  @action
  setMapPatient(PatientModel patientModel) {
    mapPatient = PatientModel().convertUserObservable(patientModel);
  }

  @action
  getValidate() {
    bool haveGender =
        mapPatient['gender'] != null && mapPatient['gender'].isNotEmpty;
    bool haveDate = mapPatient['birthday'] != null;
    bool haveAvatar = mapPatient['avatar'] != null;

    validEdit = haveGender && haveDate && haveAvatar;

    if (validEdit) {
      clearErrors();
      validEdit = true;
    } else {
      genderError = !haveGender;
      dateError = !haveDate;
      avatarError = !haveAvatar;
      validEdit = false;
    }
  }

  @action
  Future<void> clearErrors() async {
    dateError = false;
    genderError = false;
    avatarError = false;
  }

  @action
  setSelectedDate(DateTime date) {
    mapPatient['birthday'] = Timestamp.fromDate(date);
  }

  @action
  setGender({List<String> genders, bool clickItem = false, String itemName}) {
    if (clickItem) {
      mapPatient['gender'] = itemName;
      for (var i = 0; i < genders.length; i++) {
        String label = genders[i];
        if (label == itemName) {
          listGenderIndex = i;
          break;
        }
      }
    } else {
      mapPatient['gender'] = genders[listGenderIndex];
    }
    genderError = false;
  }

  Future<void> getValidEmail() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      User _user = FirebaseAuth.instance.currentUser;
      if (_user != null) {
        await _user.reload();

        if (_user.emailVerified) {
          flutterToast('O seu e-mail foi validado!');
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
    return null;
  }

  resendEmailValidation(String email, context, Function callBack) async {
    getValidateEmail() async {
      await _auth.currentUser.reload();

      try {
        print(
            'xxxxxxxxxxxx authStore.user.email ${authStore.user.email} xxxxxxxxxxxxxxx');

        await _auth.currentUser.sendEmailVerification();
        getValidEmail();
        flutterToast('Um e-mail de verificação foi enviado para sua conta.');
      } catch (e) {
        flutterToast(
            'Erro ao validar o e-mail, verifique se está tudo correto ou solicite o suporte.');

        print('xxxxxxxxxxxx ERROR: $e xxxxxxxxxxxxxxx');
      }
    }

    print(
        'xxxxxxxxxxxx resendEmailValidation ${authStore.user.phoneNumber} xxxxxxxxxxxxxxx');

    print('xxxxxxxxxxxx resendEmailValidation2 $email xxxxxxxxxxxxxxx');
    await _auth.currentUser.updateEmail(email).then((value) async {
      print('email atualizado!!!');
      await callBack();
      getValidateEmail();
      editCompleted(context);
    }).catchError((e) async {
      print('erro ao atualizar email $e');
      if (e.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        Fluttertoast.showToast(
            msg: "O e-mail digitado já está em uso!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        loadCircularEdit = false;
      }

      if (e.toString() ==
          '[firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.') {
        print(
            ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%erro ao atualizar iff ${authStore.user.phoneNumber}');

        loadCircularEdit = false;

        // reautenticando o usuário
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: FirebaseAuth.instance.currentUser.phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            print('xxxxxxxxxxxxx verificationCompleted xxxxxxxxxxxx');
          },
          verificationFailed: (FirebaseAuthException execption) {
            print('xxxxxxxxxxxxxx verificationFailed: $execption xxxxxxxxxxx');
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            print('xxxxxxxxxxxxxx codeSent $verificationId xxxxxxxxxxxxxxx');
            userVerificationId = verificationId;
            forceResendingToken = forceResendingToken;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print('xxxxxxxxx codeAutoRetrievalTimeout xxxxxxxxxx');
          },
        );

        confirmCodeOverlay = OverlayEntry(
          builder: (context) => ConfirmCode(
            resend: () {
              const oneSec = const Duration(seconds: 1);

              timerSeconds = 60;

              timerResendeCode = Timer.periodic(oneSec, (timer) {
                if (timerSeconds == 0) {
                  timerSeconds = null;
                  timer.cancel();
                } else {
                  timerSeconds--;
                }
              });

              FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: _auth.currentUser.phoneNumber,
                forceResendingToken: forceResendingToken,
                verificationCompleted:
                    (PhoneAuthCredential phoneAuthCredential) async {
                  print('xxxxxxxxxxxxx verificationCompleted xxxxxxxxxxxx');
                },
                verificationFailed: (FirebaseAuthException execption) {
                  print(
                      'xxxxxxxxxxxxxx verificationFailed: $execption xxxxxxxxxxx');
                  flutterToast(
                      'Espere alguns instantes para poder solicitar outro SMS.');
                },
                codeSent: (String verificationId, [int forceResendingToken]) {
                  print(
                      'xxxxxxxxxxxxxx codeSent $verificationId xxxxxxxxxxxxxxx');
                },
                codeAutoRetrievalTimeout: (String verificationId) {
                  print('xxxxxxxxx codeAutoRetrievalTimeout xxxxxxxxxx');
                },
              );
            },
            cancel: () async {
              await callBack();

              await FirebaseFirestore.instance
                  .collection('patients')
                  .doc(_auth.currentUser.uid)
                  .update({'email': oldEmail});
              editCompleted(context,
                  'Perfil editado com sucesso, apenas o e-mail não foi atualizado');
            },
            confirm: () async {
              try {
                AuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: userVerificationId, smsCode: code);

                final User _user =
                    (await _auth.signInWithCredential(credential)).user;

                await _user.updateEmail(email).then((value) async {
                  print('email atualizado!!! 2');
                  await callBack();
                  getValidateEmail();
                  userVerificationId = null;
                  code = null;
                  loadCircularCode = false;
                  editCompleted(context);
                }).catchError((e) async {
                  print('erro ao atualizar email 2:');
                  print(e);
                  if (e.toString() ==
                      '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
                    Fluttertoast.showToast(
                        msg: "O e-mail digitado já está em uso!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    loadCircularCode = false;

                    if (confirmCodeOverlay != null &&
                        confirmCodeOverlay.mounted) {
                      confirmCodeOverlay.remove();
                    }
                  } else {
                    await callBack();
                    loadCircularCode = false;
                    editCompleted(context,
                        'Perfil editado com sucesso, apenas o e-mail não foi atualizado');
                  }
                });
              } catch (e) {
                print('%%%%%%%%%%% error: $e %%%%%%%%%%%');
                loadCircularCode = false;

                Fluttertoast.showToast(
                    msg: "Código inválido!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
          ),
        );

        Overlay.of(context).insert(confirmCodeOverlay);
      }
    });
  }

  @action
  confirmEdit(context) async {
    loadCircularEdit = true;
    String newEmail;
    DocumentSnapshot updateUser = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();

    oldEmail = updateUser['email'];

    await setAddressKeys();

    if (addressKeys != null) {
      mapPatient['address_keys'] = addressKeys;
    }

    addressKeys.clear();

    print('xxxxxx mapPatient $mapPatient xxxxxxx');

    print('xxxxxx mapPatient ${mapPatient['email']} xxxxxxx');
    print('xxxxxx updatedUser ${updateUser.data()} xxxxxxx');

    newEmail = mapPatient['email'];

    if (newEmail != null && oldEmail != newEmail) {
      await resendEmailValidation(mapPatient['email'], context, () async {
        await updateUser.reference.update(mapPatient);
      });
    } else {
      await updateUser.reference.update(mapPatient);

      editCompleted(context);
    }
  }

  void editCompleted(context, [String text = "Perfil editado com sucesso"]) {
    if (confirmCodeOverlay != null && confirmCodeOverlay.mounted) {
      confirmCodeOverlay.remove();
    }

    newListCitys = [];
    newListStates = [];

    addressKeys.clear();

    oldEmail = null;

    loadCircularEdit = false;

    Modular.to.pop();

    confirmEditOverlay = OverlayEntry(
      builder: (context) {
        return ConfirmProfileEdit(
          onConfirm: () {
            confirmEditOverlay.remove();
            confirmEditOverlay = null;
          },
          text: text,
        );
      },
    );

    Overlay.of(context).insert(confirmEditOverlay);
  }

  @action
  String converterDate(Timestamp date, bool hint) {
    return !hint
        ? date != null
            ? date.toDate().day.toString().padLeft(2, '0') +
                '/' +
                date.toDate().month.toString().padLeft(2, '0') +
                '/' +
                date.toDate().year.toString()
            : null
        : 'Ex: ' +
            DateTime.now().day.toString().padLeft(2, '0') +
            '/' +
            DateTime.now().month.toString().padLeft(2, '0') +
            '/' +
            DateTime.now().year.toString();
  }

  @action
  pickImage() async {
    if (await Permission.storage.request().isGranted) {
      loadCircularAvatar = true;

      File _imageFile;
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) _imageFile = File(pickedFile.path);

      if (_imageFile != null) {
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
            'patients/${authStore.user.uid}/avatar/${_imageFile.path[0]}');

        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

        TaskSnapshot taskSnapshot = await uploadTask;

        taskSnapshot.ref.getDownloadURL().then((downloadURL) async {
          mapPatient['avatar'] = downloadURL;
          avatarError = false;
          loadCircularAvatar = false;
        });
      } else {
        loadCircularAvatar = false;
      }
    }
  }

  @action
  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
      context: context,
      initialDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF41c3b3),
            accentColor: const Color(0xFF21bcce),
            colorScheme: ColorScheme.light(primary: const Color(0xFF41c3b3)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      setSelectedDate(picked);

      dateError = false;
    }
  }

  @action
  getMask(dynamic value, String type) {
    String newHint;

    if (value != null) {
      switch (type) {
        case 'cpf':
          if (value.length < 11) {
            return value;
          } else {
            newHint = value.substring(0, 3);
            newHint += '.' + value.substring(3, 6);
            newHint += '.' + value.substring(6, 9);
            newHint += '-' + value.substring(9, 11);

            return newHint;
          }
          break;

        case 'cep':
          if (value.length < 8) {
            return value;
          } else {
            newHint = value.substring(0, 2);
            newHint += '.';
            newHint += value.substring(2, 5);
            newHint += '-';
            newHint += value.substring(5, 8);

            return newHint;
          }
          break;

        case 'phone':
          if (value.length < 14) {
            return value;
          } else {
            newHint = value.substring(0, 3);
            newHint += ' (';
            newHint += value.substring(3, 5);
            newHint += ') ';
            newHint += value.substring(5, 10);
            newHint += '-';
            newHint += value.substring(10, 14);
            return newHint;
          }
          break;

        case 'birthday':
          DateTime date = value.toDate();
          newHint = date.day.toString().padLeft(2, '0') +
              '/' +
              date.month.toString().padLeft(2, '0') +
              '/' +
              date.year.toString();
          return newHint;
          break;

        default:
          return value;
          break;
      }
    } else {
      return null;
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
}
