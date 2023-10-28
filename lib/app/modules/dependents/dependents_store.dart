import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/dependent_model.dart';
import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'dependents_store.g.dart';

class DependentsStore = _DependentsStoreBase with _$DependentsStore;

abstract class _DependentsStoreBase with Store {
  final AuthStore authStore = Modular.get();

  // add dependent begin

  @observable
  ObservableMap<String, dynamic> mapDependentAdd =
      PatientModel().toJson(PatientModel(type: 'DEPENDENT')).asObservable();
  @observable
  int listGenderIndex = 0;
  @observable
  bool genderDialog = false;
  @observable
  FocusNode focusNodeCity;
  @observable
  FocusNode focusNodeState;
  @observable
  bool stateError = false;
  @observable
  bool cityError = false;
  @observable
  bool genderError = false;
  @observable
  bool dateError = false;
  @observable
  bool valid = false;
  @observable
  bool input = false;
  @observable
  bool loadCircular = false;
  @observable
  bool needCpf = true;
  @observable
  List listCitys = [], listStates = [];
  @observable
  List newListCitys = [], newListStates = [];
  @observable
  TextEditingController textEditingControllerCity = TextEditingController(),
      textEditingControllerState = TextEditingController();

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
    newListStates = [];
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
  back() {
    mapDependentAdd.clear();
    loadCircular = false;
    clearErrors();
  }

  @action
  getValidate() {
    bool returnValue;
    bool haveGender = mapDependentAdd['gender'] != null &&
        mapDependentAdd['gender'].isNotEmpty;
    bool haveDate = mapDependentAdd['birthday'] != null;
    bool haveState =
        mapDependentAdd['state'] != null && mapDependentAdd['state'].isNotEmpty;
    bool haveCity =
        mapDependentAdd['city'] != null && mapDependentAdd['city'].isNotEmpty;

    returnValue = haveGender && haveDate && haveState && haveCity;

    if (returnValue) {
      clearErrors();
      valid = true;
    } else {
      genderError = !haveGender;
      dateError = !haveDate;
      stateError = !haveState;
      cityError = !haveCity;
      valid = false;
    }
  }

  @action
  clearErrors() {
    dateError = false;
    genderError = false;
    stateError = false;
    cityError = false;
  }

  @action
  void filterListCity(String text, [bool routerEdit = false]) {
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

  Future<void> getCitys([bool routerEdit = false]) async {
    newListCitys = [];
    listCitys = [];
    QuerySnapshot aux =
        await FirebaseFirestore.instance.collection('info').get();

    QuerySnapshot states =
        await aux.docs.first.reference.collection('states').get();

    states.docs.forEach((DocumentSnapshot state) {
      if (routerEdit) {
        if (state['name'] == mapDependentUpdate['state']) {
          listCitys = state['citys'];
        }
      } else {
        if (state['name'] == mapDependentAdd['state']) {
          listCitys = state['citys'];
        }
      }
    });
  }

  @action
  String converterDate(Timestamp date, [bool text = false]) {
    return !text
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
  setSelectedDate(DateTime date) {
    mapDependentAdd['birthday'] = Timestamp.fromDate(date);
  }

  @action
  confirmAddDependent() async {
    print('mapDependentAdd: $mapDependentAdd');

    DocumentReference userReference = await FirebaseFirestore.instance
        .collection('patients')
        .add(mapDependentAdd);

    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();

    await _user.reference.collection('dependents').doc(userReference.id).set({
      'fullname': mapDependentAdd['fullname'],
      'status': 'ACTIVE',
    });

    await userReference.update({
      'id': userReference.id,
      'created_at': FieldValue.serverTimestamp(),
      'responsible_id': authStore.user.uid,
      'username': mapDependentAdd['fullname'],
      'status': 'ACTIVE',
      'country': 'Brasil',
      'connected': false,
      'notification_disabled': false,
      'new_notification': null,
      'support_notifications': null,
      'type': 'DEPENDENT',
      'avatar': null,
      'address_keys': null,
    });

    if (mapDependentAdd['number_address'] == null) {
      await userReference.update({'number_address': null});
    }

    if (mapDependentAdd['complement_address'] == null) {
      await userReference.update({'complement_address': null});
    }

    if (mapDependentAdd['neighborhood'] == null) {
      await userReference.update({'neighborhood': null});
    }

    if (mapDependentAdd['cpf'] == null || mapDependentAdd['cpf'].length < 11) {
      await userReference.update({'cpf': null});
    }

    Modular.to.pop();
    back();
  }

  @action
  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
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
      dateError = false;
      int years = DateTime.now().year - picked.year;
      print("##### YEARS: $years");
      needCpf = years >= 18;
      setSelectedDate(picked);
    }
  }
  // end

  // edit dependent begin
  @observable
  ObservableMap<String, dynamic> mapDependentUpdate = ObservableMap();
  @observable
  int listGenderIndexEdit = 0;
  @observable
  bool genderDialogEdit = false;
  @observable
  bool removeDependent = false;
  @observable
  bool validEdit = false;
  @observable
  bool genderErrorEdit = false;
  @observable
  bool dateErrorEdit = false;
  @observable
  bool stateErrorEdit = false;
  @observable
  bool cityErrorEdit = false;
  @observable
  FocusNode focusNodeCityEdit;
  @observable
  FocusNode focusNodeStateEdit;
  @observable
  bool inputEdit = false;
  @observable
  TextEditingController textEditingControllerCityEdit = TextEditingController();
  @observable
  TextEditingController textEditingControllerStateEdit =
      TextEditingController();

  @action
  editDependent(String dependentId) async {
    DocumentSnapshot docDependent = await FirebaseFirestore.instance
        .collection('patients')
        .doc(dependentId)
        .get();

    DependentModel dependentModel = DependentModel.fromDocument(docDependent);

    Modular.to.pushNamed('/dependents/dependent', arguments: dependentModel);
  }

  @action
  clearErrorsEdit() {
    dateErrorEdit = false;
    genderErrorEdit = false;
    stateErrorEdit = false;
    cityErrorEdit = false;
  }

  @action
  getValidateEdit() {
    bool returnValue;
    bool haveGender = mapDependentUpdate['gender'] != null &&
        mapDependentUpdate['gender'].isNotEmpty;
    bool haveDate = mapDependentUpdate['birthday'] != null;
    bool haveState = mapDependentUpdate['state'] != null &&
        mapDependentUpdate['state'].isNotEmpty;
    bool haveCity = mapDependentUpdate['city'] != null &&
        mapDependentUpdate['city'].isNotEmpty;

    returnValue = haveGender && haveDate && haveState && haveCity;

    if (returnValue) {
      clearErrorsEdit();
      validEdit = true;
    } else {
      genderErrorEdit = !haveGender;
      dateErrorEdit = !haveDate;
      stateErrorEdit = !haveState;
      cityErrorEdit = !haveCity;
      validEdit = false;
    }
  }

  @action
  setSelectedDateEdit(DateTime date) {
    mapDependentUpdate['birthday'] = Timestamp.fromDate(date);
  }

  @action
  getMask(String text, String type) {
    String newText;

    switch (type) {
      case 'cpf':
        if (text != null && text.isNotEmpty) {
          newText = text.substring(0, 3);
          newText += '.' + text.substring(3, 6);
          newText += '.' + text.substring(6, 9);
          newText += '-' + text.substring(9, 11);

          return newText;
        } else {
          return null;
        }

        break;

      case 'cep':
        if (text != null && text.isNotEmpty) {
          newText = text.substring(0, 2);
          newText += '.';
          newText += text.substring(2, 5);
          newText += '-';
          newText += text.substring(5, 8);

          return newText;
        } else {
          return null;
        }
        break;

      case 'phone':
        if (text != null && text.isNotEmpty) {
          newText = text.substring(0, 3);
          newText += ' (';
          newText += text.substring(3, 5);
          newText += ') ';
          newText += text.substring(5, 10);
          newText += '-';
          newText += text.substring(10, 14);

          return newText;
        } else {
          return null;
        }
        break;

      default:
        return text;
        break;
    }
  }

  @action
  selectDateEdit(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
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
      int years = DateTime.now().year - picked.year;
      print("##### YEARS: $years");
      needCpf = years >= 18;
      setSelectedDateEdit(picked);
    }
  }

  @action
  confirmDependentEdit({String dependentId}) async {
    print('mapDependentUpdate: $mapDependentUpdate');

    DocumentSnapshot patientDependent = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .collection('dependents')
        .doc(dependentId)
        .get();

    DocumentSnapshot dependent = await FirebaseFirestore.instance
        .collection('patients')
        .doc(dependentId)
        .get();

    if (mapDependentUpdate['fullname'] != null) {
      await patientDependent.reference
          .update({'fullname': mapDependentUpdate['fullname']});
    }

    await dependent.reference.update(mapDependentUpdate);

    print('cccccccccccccccccpf ${mapDependentUpdate['cpf']}');

    if (mapDependentUpdate['cpf'] != null &&
        mapDependentUpdate['cpf'].length < 11) {
      print('cccccccccccccccccpf ${mapDependentUpdate['cpf'].length}');
      await dependent.reference.update({'cpf': null});
    }

    mapDependentUpdate.clear();

    Modular.to.pop();
  }

  @action
  confirmRemoveDependent({String dependentId}) async {
    DocumentSnapshot patient = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();

    DocumentSnapshot patientDependent =
        await patient.reference.collection('dependents').doc(dependentId).get();

    DocumentSnapshot dependent = await FirebaseFirestore.instance
        .collection('patients')
        .doc(dependentId)
        .get();

    QuerySnapshot appointments = await patient.reference
        .collection('appointments')
        .where('dependent_id', isEqualTo: dependentId)
        .get();

    appointments.docs.forEach((DocumentSnapshot appointment) {
      appointment.reference.update({'status': 'CANCELED'});
      FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointment.id)
          .get()
          .then((value) {
        value.reference.update({'status': 'CANCELED'});
      });
    });

    patientDependent.reference.update({'status': 'REMOVED'});

    dependent.reference.update({'status': 'REMOVED'});

    removeDependent = false;

    Modular.to.pop();
  }

  // end
}
