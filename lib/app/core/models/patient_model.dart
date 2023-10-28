import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

class PatientModel {
  String id;
  String avatar;
  Timestamp createdAt;
  String email;
  String fullname;
  String phone;
  String username;
  Timestamp birthday;
  String gender;
  String cep;
  String cpf;
  String address;
  String numberAddress;
  String complementAddress;
  String neighborhood;
  String city;
  String state;
  String status;
  String type;
  String country;
  bool notificationDisabled;
  String responsibleId;
  bool connected;
  List addressKeys;
  int newNotifications;
  int supportNotifications;
  List tokenId;

  PatientModel(
      {this.status,
      this.newNotifications,
      this.supportNotifications,
      this.tokenId,
      this.id,
      this.responsibleId,
      this.avatar,
      this.createdAt,
      this.email,
      this.fullname,
      this.phone,
      this.username,
      this.birthday,
      this.gender,
      this.cep,
      this.cpf,
      this.address,
      this.numberAddress,
      this.complementAddress,
      this.neighborhood,
      this.city,
      this.state,
      this.type,
      this.notificationDisabled,
      this.country,
      this.connected,
      this.addressKeys});

  factory PatientModel.fromDocument(DocumentSnapshot doc) {
    return PatientModel(
      responsibleId: doc['responsible_id'],
      id: doc['id'],
      avatar: doc['avatar'],
      createdAt: doc['created_at'],
      email: doc['email'],
      fullname: doc['fullname'],
      phone: doc['phone'],
      username: doc['username'],
      birthday: doc['birthday'],
      gender: doc['gender'],
      cep: doc['cep'],
      cpf: doc['cpf'],
      address: doc['address'],
      numberAddress: doc['number_address'],
      complementAddress: doc['complement_address'],
      neighborhood: doc['neighborhood'],
      city: doc['city'],
      state: doc['state'],
      status: doc['status'],
      notificationDisabled: doc['notification_disabled'],
      country: doc['country'],
      addressKeys: doc['address_keys'],
      type: doc['type'],
      connected: doc['connected'],
      tokenId: doc['token_id'],
      newNotifications: doc['new_notifications'],
      supportNotifications: doc['support_notifications'],
    );
  }

  Map<String, dynamic> convertUser(PatientModel patient) {
    Map<String, dynamic> map = {};
    map['id'] = patient.id;
    map['responsible_id'] = patient.responsibleId;
    map['avatar'] = patient.avatar;
    map['created_at'] = patient.createdAt;
    map['email'] = patient.email;
    map['fullname'] = patient.fullname;
    map['phone'] = patient.phone;
    map['username'] = patient.username;
    map['birthday'] = patient.birthday;
    map['gender'] = patient.gender;
    map['cep'] = patient.cep;
    map['cpf'] = patient.cpf;
    map['address'] = patient.address;
    map['number_address'] = patient.numberAddress;
    map['complement_address'] = patient.complementAddress;
    map['neighborhood'] = patient.neighborhood;
    map['city'] = patient.city;
    map['state'] = patient.state;
    map['notification_disabled'] = patient.notificationDisabled;
    map['country'] = patient.country;
    map['address_keys'] = patient.addressKeys;
    map['type'] = patient.type;
    map['connected'] = patient.connected;
    map['status'] = patient.status;
    map['token_id'] = patient.tokenId;
    map['new_notifications'] = patient.newNotifications;
    map['support_notifications'] = patient.supportNotifications;

    return map;
  }

  ObservableMap<String, dynamic> convertUserObservable(PatientModel patient) {
    ObservableMap<String, dynamic> map = ObservableMap();
    map['id'] = patient.id;
    map['avatar'] = patient.avatar;
    map['created_at'] = patient.createdAt;
    map['email'] = patient.email;
    map['fullname'] = patient.fullname;
    map['phone'] = patient.phone;
    map['username'] = patient.username;
    map['birthday'] = patient.birthday;
    map['gender'] = patient.gender;
    map['cep'] = patient.cep;
    map['cpf'] = patient.cpf;
    map['address'] = patient.address;
    map['number_address'] = patient.numberAddress;
    map['complement_address'] = patient.complementAddress;
    map['neighborhood'] = patient.neighborhood;
    map['city'] = patient.city;
    map['state'] = patient.state;
    map['notification_disabled'] = patient.notificationDisabled;
    map['country'] = patient.country;
    map['address_keys'] = patient.addressKeys;
    map['type'] = patient.type;
    map['status'] = patient.status;
    map['connected'] = patient.connected;
    map['token_id'] = patient.tokenId;
    map['new_notifications'] = patient.newNotifications;
    map['support_notifications'] = patient.supportNotifications;

    return map;
  }

  Map<String, dynamic> toJson(PatientModel patient) => {
        'id': patient.id,
        'avatar': patient.avatar,
        'created_at': FieldValue.serverTimestamp(),
        'email': patient.email,
        'responsible_id': patient.responsibleId,
        'fullname': patient.fullname,
        'phone': patient.phone,
        'username': patient.username,
        'birthday': patient.birthday,
        'gender': patient.gender,
        'cep': patient.cep,
        'cpf': patient.cpf,
        'address': patient.address,
        'number_address': patient.numberAddress,
        'complement_address': patient.complementAddress,
        'neighborhood': patient.neighborhood,
        'city': patient.city,
        'state': patient.state,
        'notification_disabled': patient.notificationDisabled,
        'country': patient.country,
        'address_keys': patient.addressKeys,
        'type': patient.type,
        'connected': patient.connected,
        'status': patient.status,
        'token_id': patient.tokenId,
        'new_notifications': patient.newNotifications,
        'support_notifications': patient.supportNotifications,
      };
}
