import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medibookings/model/hospital/EDAppointment/emergency_appointment.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/service_utils.dart';

class EmergencyAppointmentService extends DisposableService{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final CollectionReference edCollection = FirebaseFirestore.instance.collection(ServiceUtils.collection_emergency);
 Stream<List<EmergencyAppointmentModel>> fetchOrderedHospitalEmergencyAppointmentsStream({required DateTime dateTime, bool allAppoinment = false,int limit = 0}) {
    final startOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
    final endOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);

    Query query = edCollection
        .where(ServiceUtils.ed_hospitalId, isEqualTo: firebaseAuth.currentUser!.uid)
        .where(ServiceUtils.ed_appointmentDate, isGreaterThanOrEqualTo: startOfDay)
        .where(ServiceUtils.ed_appointmentDate, isLessThanOrEqualTo: endOfDay);

    if (!allAppoinment) {
      query = query.where(ServiceUtils.ed_isCancelled, isEqualTo: false);
    }
  
    query = query.orderBy(ServiceUtils.ed_appointmentDate, descending: true);
    if (limit > 0){
    query = query.limit(limit);
  }
    return query.snapshots().map((snapshot) {
      List<EmergencyAppointmentModel> appointments = snapshot.docs
          .map((doc) => EmergencyAppointmentModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();

      // Sort appointments by type
      appointments.sort((a, b) => a.type.index.compareTo(b.type.index));

      return appointments;
    });
  }

Future<void> updateAPpointmentStatus({required EmergencyAppointmentModel model, required bool isCancelled})async{
  try{
    model.isCancelled = isCancelled; 
     await updateAppointmentType(model);
    }
    catch(e){
      rethrow;
    }
  }


  Future<void> updateAppointmentType(EmergencyAppointmentModel model)async{
    try{
     await edCollection.doc(model.id).update(model.toMap());
    }
    catch(e){
      rethrow;
    }
  }

  
}