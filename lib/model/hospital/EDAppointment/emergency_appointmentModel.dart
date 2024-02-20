class EmergencyDepartmentAppointment {
  final int id;
  final String patientName;
  final DateTime appointmentTime;
  String priority;

  EmergencyDepartmentAppointment({
    required this.id,
    required this.patientName,
    required this.appointmentTime,
    this.priority = 'Normal', 
  });

  EmergencyDepartmentAppointment copyWith({
    String? patientName,
    DateTime? appointmentTime,
    String? priority,
  }) {
    return EmergencyDepartmentAppointment(
      id: this.id,
      patientName: patientName ?? this.patientName,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      priority: priority ?? this.priority,
    );
  }
}
