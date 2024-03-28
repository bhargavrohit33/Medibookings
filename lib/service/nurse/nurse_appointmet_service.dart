import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:medibookings/model/nurse/appointment.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/service_utils.dart';

class  NurseAppointmentService extends DisposableService{

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference collection_nurseAppointment =
      FirebaseFirestore.instance
          .collection(ServiceUtils.collection_nurseAppointment);
  final currentUser = FirebaseAuth.instance.currentUser;

    Stream<List<NurseAppointment>> get nurseAppointments {
  return FirebaseFirestore.instance
      .collection(ServiceUtils.collection_nurseAppointment)
      .where(ServiceUtils.nurseAppointment_nurseID, isEqualTo: currentUser!.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => NurseAppointment.fromSnapshot(doc))
          .toList());
}
Stream<List<NurseAppointment>> get pendingNurseAppointmentsTodayOrGreaterThanToday {
  final now = DateTime.now();
  final today = DateTime(now.year,now.month,now.day,0,0,0,);

  return FirebaseFirestore.instance
      .collection(ServiceUtils.collection_nurseAppointment)
      .where(ServiceUtils.nurseAppointment_nurseID, isEqualTo: currentUser!.uid)
      .where(ServiceUtils.nurseAppointment_status, isEqualTo: AppointmentStatus.Pending.stringValue)
      .where(ServiceUtils.nurseAppointment_serviceDateTime, isGreaterThanOrEqualTo: today)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => NurseAppointment.fromSnapshot(doc))
          
          .toList());
}

Future<String> getAddressFromLatLng({required double latitude, required double longitude}) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks.first;
    String address = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
    return address;
  } catch (e) {
    print('Error getting address: $e');
    return 'Unknown';
  }
}
 Future<void> updateAppointmentBooking(NurseAppointment nurseAppointment) async {
    try{
      await collection_nurseAppointment.doc(nurseAppointment.appointmentID).update(nurseAppointment.toMap());
    }
    catch(e){
      throw e;
    }
  }
}