import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medibookings/model/hospital/EDAppointment/emergency_appointment.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/service_utils.dart';

class EmergencyAppointmentService extends DisposableService{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final CollectionReference edCollection = FirebaseFirestore.instance.collection(ServiceUtils.collection_emergency);
  Stream<List<EmergencyAppointmentModel>> fetchOrderedHospitalEmergencyAppointmentsStream(DateTime dateTime) {
  final startOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
  final endOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  
  return edCollection
      .where(ServiceUtils.ed_hospitalId, isEqualTo: firebaseAuth.currentUser!.uid)
      .where(ServiceUtils.ed_appointmentDate, isGreaterThanOrEqualTo: startOfDay)
      .where(ServiceUtils.ed_appointmentDate, isLessThanOrEqualTo: endOfDay)
      .where(ServiceUtils.ed_isCancelled, isEqualTo: false)
      .orderBy(ServiceUtils.ed_appointmentDate,descending: true)
      .snapshots()
      .map((snapshot) {
        List<EmergencyAppointmentModel> appointments = snapshot.docs
            .map((doc) => EmergencyAppointmentModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>> ))
            .toList();

        // Filter appointments by type
        List<EmergencyAppointmentModel> emergencyAppointments = appointments
            .where((appointment) => appointment.type == EmergencyType.emergency)
            .toList();

        List<EmergencyAppointmentModel> urgentAppointments = appointments
            .where((appointment) => appointment.type == EmergencyType.urgent)
            .toList();

        List<EmergencyAppointmentModel> normalAppointments = appointments
            .where((appointment) => appointment.type == EmergencyType.normal)
            .toList();

        // Combine all appointments and sort them
        List<EmergencyAppointmentModel> orderedAppointments = [];
        orderedAppointments.addAll(emergencyAppointments);
        orderedAppointments.addAll(urgentAppointments);
        orderedAppointments.addAll(normalAppointments);

        return orderedAppointments;
      });
}


  Future<void> updateAppointmentType(EmergencyAppointmentModel model)async{
    try{
     await edCollection.doc(model.id).update(model.toMap());
    }
    catch(e){
      throw e;
    }
  }

  
}