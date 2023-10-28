import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentModel {
  Timestamp createdAt;
  Timestamp date;
  Timestamp hour;
  Timestamp endHour;
  String doctorId;
  String scheduleId;
  String patientId;
  String id;
  String status;
  String type;
  String contact;
  String patientName;
  String note;
  String dependentId;
  bool covidSymptoms;
  bool firstVisit;
  bool rated;
  bool canceledByDoctor;
  bool rescheduled;

  final num price;

  AppointmentModel({
    this.dependentId,
    this.rated = false,
    this.note,
    this.contact,
    this.patientName,
    this.covidSymptoms,
    this.firstVisit,
    this.createdAt,
    this.date,
    this.hour,
    this.endHour,
    this.doctorId,
    this.scheduleId,
    this.patientId,
    this.id,
    this.status,
    this.type,
    this.price,
    this.canceledByDoctor,
    this.rescheduled,
  });

  factory AppointmentModel.fromDocumentSnapshot(DocumentSnapshot doc) =>
      AppointmentModel(
        dependentId: doc['dependent_id'],
        note: doc['note'],
        contact: doc['contact'],
        patientName: doc['patient_name'],
        covidSymptoms: doc['covid_symptoms'],
        firstVisit: doc['first_visit'],
        createdAt: doc['created_at'],
        date: doc['date'],
        hour: doc['hour'],
        endHour: doc['end_hour'],
        doctorId: doc['doctor_id'],
        scheduleId: doc['schedule_id'],
        patientId: doc['patient_id'],
        id: doc['id'],
        status: doc['status'],
        type: doc['type'],
        price: doc['price'],
        rated: doc['rated'],
        canceledByDoctor: doc['canceled_by_doctor'],
        rescheduled: doc['rescheduled'],
      );

  Map<String, dynamic> toJson(AppointmentModel appointment) => {
        'dependent_id': appointment.dependentId,
        'note': appointment.note,
        'contact': appointment.contact,
        'patient_name': appointment.patientName,
        'covid_symptoms': appointment.covidSymptoms,
        'first_visit': appointment.firstVisit,
        'created_at': FieldValue.serverTimestamp(),
        'date': appointment.date,
        'hour': appointment.hour,
        'end_hour': appointment.endHour,
        'doctor_id': appointment.doctorId,
        'schedule_id': appointment.scheduleId,
        'patient_id': appointment.patientId,
        'id': appointment.id,
        'status': appointment.status,
        'type': appointment.type,
        'price': appointment.price,
        'rated': appointment.rated,
        'canceled_by_doctor': appointment.canceledByDoctor,
        'rescheduled': appointment.rescheduled,
      };
}

class Meeting {
  Meeting({
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.id,
    this.type,
    this.totalVacancies,
    this.availableVcancies,
    this.occupiedVacancies,
  });

  String eventName;
  String id;
  String type;

  int totalVacancies;
  int availableVcancies;
  int occupiedVacancies;

  DateTime from;
  DateTime to;

  Color background;

  bool isAllDay;

  Map<String, dynamic> toJson(Meeting meeting) => {
        'total_vacancies': meeting.totalVacancies,
        'available_vacancies': meeting.availableVcancies,
        'occupied_vacancies': meeting.occupiedVacancies,
        'id': meeting.id,
        'event_name': meeting.eventName,
        'from': meeting.from,
        'to': meeting.to,
        'background': meeting.background,
        'is_all_day': meeting.isAllDay,
      };
}
