import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medibookings/service/service_utils.dart';

class Appointment {
  final String? id;
  final String? patientId;
  final String hospitalId;
  final int timeSlotDuration;
  final String? prescriptionId;
  final String doctor;
  final DateTime appointmentDate;
  final String? referralAppointmentId;
  final bool isBooked;

  Appointment({
    this.id,
    this.patientId,
    required this.hospitalId,
    required this.timeSlotDuration,
    required this.doctor,
    required this.appointmentDate,
    this.prescriptionId,
    this.referralAppointmentId,
    required this.isBooked
  });

  factory Appointment.fromMap(DocumentSnapshot snapshot) {
    return Appointment(
      id: snapshot[ServiceUtils.appointmentModel_Id]?? "",
      patientId: snapshot[ServiceUtils.appointmentModel_PatientId]?? "",
      hospitalId: snapshot[ServiceUtils.appointmentModel_HospitalId]?? "",
      timeSlotDuration: snapshot[ServiceUtils.appointmentModel_TimeSlotDuration],
      prescriptionId: snapshot[ServiceUtils.appointmentModel_PrescriptionId]?? "",
      doctor: snapshot[ServiceUtils.appointmentModel_Doctor]?? "",
      appointmentDate: DateTime.parse(snapshot[ServiceUtils.appointmentModel_AppointmentDate]?? ""),
      referralAppointmentId: snapshot[ServiceUtils.appointmentModel_ReferralAppointmentId]?? "",
      isBooked: snapshot[ServiceUtils.appointmentModel_isBooked]?? ""
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ServiceUtils.appointmentModel_Id: id,
      ServiceUtils.appointmentModel_PatientId: patientId,
      ServiceUtils.appointmentModel_HospitalId: hospitalId,
      ServiceUtils.appointmentModel_TimeSlotDuration: timeSlotDuration,
      ServiceUtils.appointmentModel_PrescriptionId: prescriptionId,
      ServiceUtils.appointmentModel_Doctor: doctor,
      ServiceUtils.appointmentModel_AppointmentDate: appointmentDate.toIso8601String(),
      ServiceUtils.appointmentModel_ReferralAppointmentId: referralAppointmentId,
      ServiceUtils.appointmentModel_isBooked:isBooked
    };
  }
}
