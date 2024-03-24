import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/service/service_utils.dart';


class NurseAppointment {
  final String? appointmentID;
  final String nurseID;
  final String patientID;
   AppointmentStatus appointmentStatus;
  final DateTime appointmentDate;
  final String note;
  final String requestedService;
  final Duration durationOfService;
  final double total;

  NurseAppointment({
     this.appointmentID,
    required this.nurseID,
    required this.patientID,
    required this.appointmentStatus,
    required this.appointmentDate,
    required this.note,
    required this.requestedService,
    required this.durationOfService,
    required this.total,
  });

  static NurseAppointment fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return NurseAppointment(
      appointmentID: snapshot.id,
      nurseID: snapshot.data()![ServiceUtils.nurseAppointment_nurseID],
      patientID: snapshot.data()![ServiceUtils.nurseAppointment_patientID],
      appointmentStatus: appointmentStatusFromString(
          snapshot.data()![ServiceUtils.nurseAppointment_status]),
      appointmentDate: snapshot
          .data()![ServiceUtils.nurseAppointment_appointmentDate]
          .toDate(),
      note: snapshot.data()![ServiceUtils.nurseAppointment_note] ?? "",
      requestedService:
          snapshot.data()![ServiceUtils.nurseAppointment_requestService] ?? "",
      durationOfService: Duration(
          minutes: snapshot
              .data()![ServiceUtils.nurseAppointment_durationOfService]),
      total: snapshot.data()![ServiceUtils.nurseAppointment_total] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ServiceUtils.nurseAppointment_nurseID: nurseID,
      ServiceUtils.nurseAppointment_patientID: patientID,
      ServiceUtils.nurseAppointment_status: appointmentStatus.stringValue,
      ServiceUtils.nurseAppointment_appointmentDate: appointmentDate,
      ServiceUtils.nurseAppointment_note: note,
      ServiceUtils.nurseAppointment_requestService:
          requestedService.toLowerCase(),
      ServiceUtils.nurseAppointment_durationOfService:
          durationOfService.inMinutes,
      ServiceUtils.nurseAppointment_total: total,
    };
  }
}

enum AppointmentStatus {
  Pending,
  Approved,
  Rejected,
  CancelledByPatient,
}

extension AppointmentStatusExtension on AppointmentStatus {
  String get stringValue {
    switch (this) {
      case AppointmentStatus.Pending:
        return 'Pending';
      case AppointmentStatus.Approved:
        return 'Approved';
      case AppointmentStatus.Rejected:
        return 'Rejected';
      case AppointmentStatus.CancelledByPatient:
        return 'CancelledByPatient';
      default:
        throw Exception('Invalid appointment status');
    }
  }
}

AppointmentStatus appointmentStatusFromString(String statusString) {
  switch (statusString) {
    case 'Pending':
      return AppointmentStatus.Pending;
    case 'Approved':
      return AppointmentStatus.Approved;
    case 'Rejected':
      return AppointmentStatus.Rejected;
      // same
    case 'CancelledByPatient':
      return AppointmentStatus.CancelledByPatient;
      case 'CancelledByMe':
      return AppointmentStatus.CancelledByPatient;
        // same end
    default:
      throw Exception('Invalid appointment status string');
  }
}
