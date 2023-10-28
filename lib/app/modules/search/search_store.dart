import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/doctor_model.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'search_store.g.dart';

class SearchStore = _SearchStoreBase with _$SearchStore;

abstract class _SearchStoreBase with Store {
  final AuthStore authStore = Modular.get();

  // @observable
  // String city;
  @observable
  String speciality;
  @observable
  String specialityID;
  @observable
  ObservableList substr1 = [].asObservable();
  @observable
  List substr2 = [];
  @observable
  DocumentSnapshot patientDoc;
  @observable
  bool nextTap = true;
  @observable
  int startWithIndex;
  @observable
  String local = 'city';
  @observable
  TextEditingController locController = TextEditingController();
  @observable
  TextEditingController spcController = TextEditingController();
  @observable
  bool firstLook = false;
  @observable
  QuerySnapshot specialities;
  @observable
  String stateOrCity;

  @action
  setNextTap() => nextTap = !nextTap;
  @action
  setSpecialtyID(String spc) => specialityID = spc;
  @action
  setSpecialty(String spc) => speciality = spc;
  // @action
  // setLocation(String lc) => city = lc;
  @action
  setLength(int lg) => startWithIndex = lg;
  @action
  resetLocal() => local = 'city';

  @action
  getLocation(String locate) async {
    substr1.clear();
    patientDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();

    // state = patientDoc.get('state');

    stateOrCity = patientDoc.get('state');
    substr1.add(patientDoc.get('state').substring(0, 4).toUpperCase());
    locController.text = stateOrCity;
    firstLook = true;

    specialities =
        await FirebaseFirestore.instance.collection('specialties').get();
  }

  @action
  localSearch(String search, int length) async {
    if (search.length == 0) {
      if (patientDoc.get('city') != null) {
        substr1.add(patientDoc.get('city').substring(0, 4).toUpperCase());
        stateOrCity = patientDoc.get('city');
      }
    }

    for (var i = 0; i < length; i++) {
      if (length > 2 && length <= 5) {
        substr1.clear();
        substr1.add(search.substring(0, 3).toUpperCase());
        substr1.add(search.substring(0, length).toUpperCase());
      } else if (length > 5) {
        substr1.clear();
        substr1.add(search.substring(0, length).toUpperCase());
      } else {
        substr1.clear();
        substr1.add(search.substring(0, length).toUpperCase());
      }
    }
    if (length == 0) {
      substr1.clear();
    }
  }

  @action
  specialSearch(String search, int length) async {
    substr2 = [];
    bool hasDr = false;

    for (var i = 0; i < length; i++) {
      if (length == 1) {
        substr2.clear();
        substr2.add(search.substring(0, length).toUpperCase());
      }
      if (length > 2 && length <= 5) {
        substr2.clear();
        substr2.add(search.substring(0, 3).toUpperCase());
        substr2.add(search.substring(0, length).toUpperCase());
      } else if (length > 5) {
        substr2.clear();
        substr2.add(search.substring(0, length).toUpperCase());
      } else {
        substr2.clear();
        substr2.add(search.substring(0, length).toUpperCase());
      }
    }

    for (var i = 0; i < specialities.docs.length; i++) {
      for (var ii = 0; ii < substr2.length; ii++) {
        if (specialities.docs[i].get('speciality_keys').contains(substr2[ii])) {
          hasDr = true;
        }
      }
    }

    if (hasDr) {
      QuerySnapshot spequery = await FirebaseFirestore.instance
          .collection('specialties')
          .where('speciality_keys', arrayContainsAny: substr2)
          .get();

      speciality = spequery.docs.first.get('speciality');
      specialityID = spequery.docs.first.get('id');
      print('specialityspecialityspecialityspeciality   $speciality');
      print('specialityIDspecialityIDspecialityID   $specialityID');
    }

    if (!hasDr) {
      specialityID = '';
    }

    if (length == 0) {
      speciality = null;
      specialityID = null;
    }
  }

  address(String state, String city, String neighbor) {
    Map locMap = {};
    List aux1 = [];
    List aux2 = [];
    List aux3 = [];

    for (var i = 0; i < neighbor.length; i++) {
      aux1.add(neighbor.substring(0, i + 1).toUpperCase());

      if (neighbor.length == i + 1) {
        locMap['neighborhood'] = aux1;
      }
    }
    for (var i = 0; i < city.length; i++) {
      aux2.add(city.substring(0, i + 1).toUpperCase());

      if (city.length == i + 1) {
        locMap['city'] = aux2;
      }
    }
    for (var i = 0; i < state.length; i++) {
      aux3.add(state.substring(0, i + 1).toUpperCase());

      if (state.length == i + 1) {
        locMap['state'] = aux3;
      }
    }

    MapEntry entry = locMap.entries.firstWhere(
        (element) => element.value.contains(substr1.last),
        orElse: () => null);

    if (entry != null) {
      local = entry.key;
    }
  }

  @action
  viewDrProfile(String doctorId) async {
    if (authStore.user.uid != doctorId) {
      DocumentSnapshot doctor = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();

      DoctorModel doctorModel = DoctorModel.fromDocument(doctor);

      Modular.to.pushNamed('/drprofile', arguments: doctorModel);
    }
  }

  setLocKeys() async {
    QuerySnapshot drs =
        await FirebaseFirestore.instance.collection('doctors').get();

    drs.docs.forEach((value) async {
      List address = [];

      for (var i = 1; i < value['city'].toString().length + 1; ++i) {
        address.add(value['city'].substring(0, i).toUpperCase());
      }

      for (var i = 1; i < value['state'].toString().length + 1; ++i) {
        address.add(value['state'].substring(0, i).toUpperCase());
      }

      await value.reference.update({'address_keys': address});
    });
  }

  quickFix() {
    FirebaseFirestore.instance.collection('doctors').get().then((value) {
      value.docs.forEach((element) {
        if (element.id.length == 20) {
          element.reference.delete();
        }
      });
    });
  }
}
