import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/service/service_utils.dart';


class Appointment {
  final String? id;
  final String? patientId;
  final String hospitalId;
  final int timeSlotDuration;
  final String? prescriptionId;
  final String doctorid;
  final DateTime appointmentDate;
  final DateTime? referralAppointmentId;
  final bool isBooked;
  final Map<String, dynamic>? familyMember; 

  Appointment({
    this.id,
    this.patientId,
    required this.hospitalId,
    required this.timeSlotDuration,
    required this.doctorid,
    required this.appointmentDate,
    this.prescriptionId,
    this.referralAppointmentId,
    required this.isBooked,
    this.familyMember // Nullable map
  });

  factory Appointment.fromSnapshot(DocumentSnapshot snapshot) {
    return Appointment(
      id: snapshot[ServiceUtils.appointmentModel_Id] ?? "",
      patientId: snapshot[ServiceUtils.appointmentModel_PatientId] ?? "",
      hospitalId: snapshot[ServiceUtils.appointmentModel_HospitalId] ?? "",
      timeSlotDuration: snapshot[ServiceUtils.appointmentModel_TimeSlotDuration],
      prescriptionId: snapshot[ServiceUtils.appointmentModel_PrescriptionId] ?? "",
      doctorid: snapshot[ServiceUtils.appointmentModel_Doctor] ?? "",
      appointmentDate: (snapshot[ServiceUtils.appointmentModel_AppointmentDate] as Timestamp).toDate(),
      referralAppointmentId: snapshot[ServiceUtils.appointmentModel_ReferralAppointmentId] != null ? (snapshot[ServiceUtils.appointmentModel_ReferralAppointmentId] as Timestamp).toDate() : null,
      isBooked: snapshot[ServiceUtils.appointmentModel_isBooked] ?? "",
      familyMember: snapshot[ServiceUtils.appointmentModel_familyMember] as Map<String, dynamic>? ?? {}, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
     
      ServiceUtils.appointmentModel_PatientId: patientId,
      ServiceUtils.appointmentModel_HospitalId: hospitalId,
      ServiceUtils.appointmentModel_TimeSlotDuration: timeSlotDuration,
      ServiceUtils.appointmentModel_PrescriptionId: prescriptionId,
      ServiceUtils.appointmentModel_Doctor: doctorid,
      ServiceUtils.appointmentModel_AppointmentDate: appointmentDate,
      ServiceUtils.appointmentModel_ReferralAppointmentId: referralAppointmentId,
      ServiceUtils.appointmentModel_isBooked: isBooked,
      ServiceUtils.appointmentModel_familyMember: familyMember, 
    };
  }
}
