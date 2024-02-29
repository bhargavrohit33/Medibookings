import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/service_utils.dart';

class HospitalAppointmentService extends DisposableService{
   final CollectionReference appointmentCollection =
      FirebaseFirestore.instance.collection(ServiceUtils.collection_appointment);
  Future<void> uploadAppointment(List<Appointment> appointments) async {
 

  try {
    for (Appointment appointment in appointments) {
      // Convert appointment object to map
      Map<String, dynamic> appointmentMap = appointment.toMap();

      // Add appointment to Firestore
      await appointmentCollection.add(appointmentMap);
    }
    print('Appointments updated successfully.');
  } catch (e) {
    print('Error updating appointments: $e');
    throw e;
  }
}

Stream<List<Appointment>> getAppointmentsForDoctor(String doctorId) {
  return appointmentCollection
      .where(ServiceUtils.appointmentModel_Doctor, isEqualTo: doctorId)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => Appointment.fromMap(doc))
          .toList());
}

}