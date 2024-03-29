import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/model/hospital/patient/patient_model.dart';
import 'package:medibookings/model/nurse/appointment.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';

class AppointmentDetailModel {
  final Appointment appointment;
  final PatientModel patientModel;
  final Doctor doctor;
  const AppointmentDetailModel(
      {required this.appointment,
      required this.patientModel,
      required this.doctor});
}

class DoctorArugument {
  final String doctorId;
  final String hospitalId;
  final bool isUSerCanBookAppointment;
  DoctorArugument(
      {required this.doctorId,
      required this.hospitalId,
      required this.isUSerCanBookAppointment});
}

class NurseAppointmentRouteAruguments {
  final NurseAppointment nurseAppointment;
  final PatientModel patientModel;
  NurseAppointmentRouteAruguments(
      {required this.nurseAppointment, required this.patientModel});
}
