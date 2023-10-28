import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/doctor_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'specialty_store.g.dart';

class SpecialtyStore = _SpecialtyStoreBase with _$SpecialtyStore;

abstract class _SpecialtyStoreBase with Store {
  @observable
  int value = 0;
  @observable
  bool editing = false, showMenuFilter = false;
  @observable
  String speciality;
  @observable
  ObservableMap mapRatings = ObservableMap();
  @observable
  ObservableList listDoctors;
  @observable
  int indexFilter = 0;
  @observable
  bool setCards = false;

  @action
  setEditing(bool value) => editing = value;
  @action
  setCardDialog(bool c) => setCards = c;

  @observable
  bool onEditing = false;

  @action
  setOnEditing(bool value) => onEditing = value;

  @action
  getDoctors(String specId) async {
    QuerySnapshot doctors = await FirebaseFirestore.instance
        .collection('doctors')
        .where('speciality', isEqualTo: specId)
        .where('premium', isEqualTo: true)
        .where('status', isEqualTo: 'ACTIVE')
        .get();

    listDoctors = [].asObservable();

    doctors.docs.forEach((element) {
      listDoctors.add(element.data());
    });

    // listDoctors = doctors.docs.toList().asObservable();

    if (indexFilter == 1) {
      listDoctors.forEach((doctor) {
        doctor['avaliation'] = mapRatings[doctor['id']].last;
      });
      listDoctors.sort((a, b) {
        return b['avaliation'].toString().compareTo(a['avaliation'].toString());
      });
    }

    if (indexFilter == 2) {
      listDoctors.sort((a, b) {
        return a['price'].compareTo(b['price']);
      });
    }

    if (indexFilter == 3) {
      listDoctors.sort((a, b) {
        return b['price'].compareTo(a['price']);
      });
    }
  }

  @action
  viewDrProfile(String doctorId) async {
    DocumentSnapshot doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();

    DoctorModel doctorModel = DoctorModel.fromDocument(doctor);

    Modular.to.pushNamed('/drprofile', arguments: doctorModel);
  }

  @action
  getRatings(String doctorId) {
    List newList = [];
    mapRatings.putIfAbsent(doctorId, () => [0, 0.0]);

    FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('ratings')
        .where('status', isEqualTo: 'VISIBLE')
        .get()
        .then((QuerySnapshot ratings) {
      if (ratings.docs.isNotEmpty) {
        double average = 0.0;

        newList.add(ratings.docs.length.toString());

        ratings.docs.forEach((rating) {
          average += rating['avaliation'];
        });

        average = average / ratings.docs.length;

        newList.add(average.toStringAsFixed(1));

        mapRatings[doctorId] = newList;
      }
    });
  }

  @action
  fixSpec() {
    FirebaseFirestore.instance.collection('specialties').get().then((value) {
      value.docs.forEach((element) async {
        String spec = element.get('specialty');

        await element.reference.update({'specialty': FieldValue.delete()});

        await element.reference.update({'speciality': spec});
      });
    });
  }
}
