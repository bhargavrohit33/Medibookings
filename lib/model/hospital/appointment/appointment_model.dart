class Appointment {
  final int id;
  final int patientId;
  final int hospitalId;
  final int timeSlotDuration;
  final int? prescriptionId;
  final int? doctor;
  final DateTime? appointmentDate;
  final int? referralAppointmentId;

  Appointment({
    required this.id,
    required this.patientId,
    required this.hospitalId,
    required this.timeSlotDuration,
    required this.doctor,
    required this.appointmentDate,
    this.prescriptionId,
    this.referralAppointmentId,
  });

  
}
