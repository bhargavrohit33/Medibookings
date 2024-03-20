import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/service/service_utils.dart';


enum EmergencyType { normal, urgent, emergency }

class EmergencyAppointmentModel {
  final String? id;
  final String hospitalId;
  final String patientId;
  final DateTime appointmentDate;
  final String notes;
   bool isCancelled;
   EmergencyType type;

  EmergencyAppointmentModel({
    this.id,
    required this.hospitalId,
    required this.patientId,
    required this.appointmentDate,
    required this.notes,
    required this.isCancelled,
    required this.type,
  });

  factory EmergencyAppointmentModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return EmergencyAppointmentModel(
      id: snapshot.id,
      hospitalId: snapshot[ServiceUtils.ed_hospitalId] ?? "",
      patientId: snapshot[ServiceUtils.ed_patientId] ?? "",
      appointmentDate: (snapshot[ServiceUtils.ed_appointmentDate] as Timestamp).toDate(),
      notes: snapshot[ServiceUtils.ed_notes] ?? "",
      isCancelled: snapshot[ServiceUtils.ed_isCancelled] ?? false,
      type: parseEmergencyType(snapshot[ServiceUtils.ed_type] ?? "normal"),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ServiceUtils.ed_hospitalId: hospitalId,
      ServiceUtils.ed_patientId: patientId,
      ServiceUtils.ed_appointmentDate: appointmentDate,
      ServiceUtils.ed_notes: notes,
      ServiceUtils.ed_isCancelled: isCancelled,
      ServiceUtils.ed_type: convertEmergencyTypeToString(type),
    };
  }


   

 
}
  // Method to convert string to enum
EmergencyType parseEmergencyType(String typeString) {
    switch (typeString){
      case 'normal':
        return EmergencyType.normal;
      case 'urgent':
        return EmergencyType.urgent;
      case 'emergency':
        return EmergencyType.emergency;
      default:
        return EmergencyType.normal;
    }
  }
   // Method to convert enum to string
   String convertEmergencyTypeToString(EmergencyType type) {
    return type.toString().split('.').last;
  }