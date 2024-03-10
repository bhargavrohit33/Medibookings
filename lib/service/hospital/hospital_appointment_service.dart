import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/service_utils.dart';

class HospitalAppointmentService extends DisposableService{
   final CollectionReference appointmentCollection =
      FirebaseFirestore.instance.collection(ServiceUtils.collection_appointment);
    final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection(ServiceUtils.collection_doctor);


    
  HospitalAppointmentService(){
  }
      
  Future<void> uploadAppointment(List<Appointment> appointments) async {
 

  try {
    for (Appointment appointment in appointments) {
      // Convert appointment object to map
      Map<String, dynamic> appointmentMap = appointment.toMapForHospital();

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
      .orderBy(ServiceUtils.appointmentModel_AppointmentDate,descending: false)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => Appointment.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList());
}
Stream<List<Appointment>> getAppointmentsByHospitalId(String hospitalId) {
  return appointmentCollection
      .where(ServiceUtils.appointmentModel_providerId, isEqualTo: hospitalId).orderBy(ServiceUtils.appointmentModel_AppointmentDate,descending: true)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => Appointment.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList());
}

Stream<List<Appointment>> getAppointmentsNearCurrentTime(String hospitalId) {
  DateTime currentTime = DateTime.now();
  DateTime oneHourLater = currentTime.add(Duration(hours: 1));
 

  return appointmentCollection
      .where(ServiceUtils.appointmentModel_providerId, isEqualTo: hospitalId)
      .where(ServiceUtils.appointmentModel_isBooked, isEqualTo: true)
      .where(ServiceUtils.appointmentModel_AppointmentDate, isGreaterThanOrEqualTo: currentTime)
      .where(ServiceUtils.appointmentModel_AppointmentDate, isLessThanOrEqualTo: oneHourLater)
      .orderBy(ServiceUtils.appointmentModel_AppointmentDate).limit(3)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .map((doc) => Appointment.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList());
}

}