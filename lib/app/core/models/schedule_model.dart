import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  Timestamp createdAt;
  Timestamp date;
  Timestamp startHour;
  Timestamp endHour;
  String doctorId;
  String id;
  String justification;
  String status;
  String type;

  int totalVacancies;
  int availableVacancies;
  int occupiedVacancies;

  ScheduleModel({
    this.createdAt,
    this.date,
    this.startHour,
    this.endHour,
    this.doctorId,
    this.id,
    this.justification,
    this.status,
    this.type,
    this.totalVacancies,
    this.availableVacancies,
    this.occupiedVacancies,
  });

  factory ScheduleModel.fromDocumentSnapshot(DocumentSnapshot doc) =>
      ScheduleModel(
        createdAt: doc['created_at'],
        date: doc['date'],
        startHour: doc['start_hour'],
        endHour: doc['end_hour'],
        doctorId: doc['doctor_id'],
        id: doc['id'],
        status: doc['status'],
        type: doc['type'],
        totalVacancies: doc['total_vacancies'],
        availableVacancies: doc['available_vacancies'],
        occupiedVacancies: doc['occupied_vacancies'],
      );

  Map<String, dynamic> toJson(ScheduleModel schedule) => {
        'created_at': FieldValue.serverTimestamp(),
        'date': schedule.date,
        'start_hour': schedule.startHour,
        'end_hour': schedule.endHour,
        'doctor_id': schedule.doctorId,
        'id': schedule.id,
        'status': schedule.status,
        'type': schedule.type,
        'total_vacancies': schedule.totalVacancies,
        'available_vacacies': schedule.availableVacancies,
        'occupied_vacancies': schedule.occupiedVacancies,
      };
}
