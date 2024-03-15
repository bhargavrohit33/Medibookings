import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/service/service_utils.dart';


class Appointment {
  final String? id;
  final String? patientId;
  final String providerId;
  final int timeSlotDuration;
  final String? prescriptionId;
  final String doctorid;
  final DateTime appointmentDate;
  final DateTime? referralAppointmentId;
  final bool isBooked;
  final bool? isNurseProvider;
  final Map<String, dynamic>? familyMember;

  Appointment({
    this.id,
    this.patientId,
    required this.providerId,
    required this.timeSlotDuration,
    required this.doctorid,
    required this.appointmentDate,
    this.prescriptionId,
    this.referralAppointmentId,
    required this.isBooked,
     this.isNurseProvider  = false,
    this.familyMember,
  });

  factory Appointment.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Appointment(
      id: snapshot.id,
      patientId: snapshot[ServiceUtils.appointmentModel_PatientId] ?? "",
      providerId: snapshot[ServiceUtils.appointmentModel_providerId] ?? "",
      timeSlotDuration: snapshot[ServiceUtils.appointmentModel_TimeSlotDuration],
      prescriptionId: snapshot[ServiceUtils.appointmentModel_PrescriptionId] ?? "",
      doctorid: snapshot[ServiceUtils.appointmentModel_Doctor] ?? "",
      appointmentDate: (snapshot[ServiceUtils.appointmentModel_AppointmentDate] as Timestamp).toDate(),
      referralAppointmentId: snapshot[ServiceUtils.appointmentModel_ReferralAppointmentId] != null ? (snapshot[ServiceUtils.appointmentModel_ReferralAppointmentId] as Timestamp).toDate() : null,
      isBooked: snapshot[ServiceUtils.appointmentModel_isBooked] ?? "",
      isNurseProvider: snapshot[ServiceUtils.appointmentModel_isNurseProvider] ?? false,
      familyMember: snapshot[ServiceUtils.appointmentModel_familyMember] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toMapForHospital() {
    return {
      ServiceUtils.appointmentModel_PatientId: patientId,
      ServiceUtils.appointmentModel_providerId: providerId,
      ServiceUtils.appointmentModel_TimeSlotDuration: timeSlotDuration,
      ServiceUtils.appointmentModel_PrescriptionId: prescriptionId,
      ServiceUtils.appointmentModel_Doctor: doctorid,
      ServiceUtils.appointmentModel_AppointmentDate: appointmentDate,
      ServiceUtils.appointmentModel_ReferralAppointmentId: referralAppointmentId,
      ServiceUtils.appointmentModel_isBooked: isBooked,
      ServiceUtils.appointmentModel_isNurseProvider: false,
      ServiceUtils.appointmentModel_familyMember: familyMember,
    };
  }
   Map<String, dynamic> toMapForNurse() {
    return {
      ServiceUtils.appointmentModel_PatientId: patientId,
      ServiceUtils.appointmentModel_providerId: providerId,
      ServiceUtils.appointmentModel_TimeSlotDuration: timeSlotDuration,
      ServiceUtils.appointmentModel_PrescriptionId: prescriptionId,
      ServiceUtils.appointmentModel_Doctor: doctorid,
      ServiceUtils.appointmentModel_AppointmentDate: appointmentDate,
      ServiceUtils.appointmentModel_ReferralAppointmentId: referralAppointmentId,
      ServiceUtils.appointmentModel_isBooked: isBooked,
      ServiceUtils.appointmentModel_isNurseProvider: true,
      ServiceUtils.appointmentModel_familyMember: familyMember,
    };
  }
  Appointment cancelAppointment() {
    return Appointment(
      id: this.id,
      providerId:  this.providerId,
      doctorid:  this.doctorid,
      timeSlotDuration: this.timeSlotDuration,
      appointmentDate: this.appointmentDate,
      isBooked: false,
      familyMember: {},
      patientId: null

    );
  }
}
