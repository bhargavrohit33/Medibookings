
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:medibookings/service/service_utils.dart';

class DoctorService extends DisposableService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection(ServiceUtils.collection_doctor);
      final CollectionReference appointmentCollection = FirebaseFirestore.instance.collection(ServiceUtils.collection_appointment);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Doctor? doctor;
 
   HospitalService? hospitalService;

   DoctorService(HospitalService service){
    hospitalService =service;
    
   }
  @override
  void dispose() {
    // TODO: implement dispose
    doctor = null;
   
  }
  // fetch all the doctor data
  



  @override
  dynamic noSuchMethod(Invocation invocation) {
    // Handle calls to unimplemented methods here
    return super.noSuchMethod(invocation);
  }
  Future<void> setDoctor(Doctor doctor)async{
    doctor =   doctor;
    notifyListeners();
  }

  Future<bool> checkDoctorExists(String doctorName) async {
    QuerySnapshot<Object?> querySnapshot = await doctorsCollection
        .where(ServiceUtils.doctorModel_FirstName, isEqualTo: doctorName)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> createDoctorProfile(
      String firstName, String lastName, String specialization,
      {PlatformFile? file}) async {
    try {
      AuthService authService = AuthService();
      String? profileURL;
      if (file != null) {
        profileURL = await authService.uploadFile(file);
      }
      Doctor dummy = Doctor(id: '', firstName: firstName, lastName: lastName, specialization: specialization, hospitalId: firebaseAuth.currentUser!.uid,profilePhoto: profileURL);
       await doctorsCollection.add(dummy.toMap());
    //
      // await doctorsCollection.add({
      //   ServiceUtils.doctorModel_FirstName: firstName,
      //   ServiceUtils.doctorModel_LastName: lastName,
      //   ServiceUtils.doctorModel_Specialization: specialization,
      //   ServiceUtils.doctorModel_HospitalId: firebaseAuth.currentUser!.uid,
      //   ServiceUtils.doctorModel_ProfilePhoto: profileURL,
      // });
    } catch (e) {
      print('Error creating doctor profile: $e');
      rethrow;
    }
  }

  Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await doctorsCollection
          .doc(doctorId)
          .get() as DocumentSnapshot<Map<String, dynamic>>;
      if (snapshot.exists) {
        return Doctor.fromSnapshot(snapshot,);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting doctor profile: $e');
      rethrow;
    }
  }
  Stream<Doctor>  getDoctorByIdStream(String doctorId){
    return doctorsCollection.doc(doctorId)
    .snapshots().map((event) => Doctor.fromSnapshot(event));
  }

  Stream<List<Doctor>> getDoctorsByHospitalIdStream({required String hospitalId  }) {
    
    return doctorsCollection
        .where(ServiceUtils.doctorModel_HospitalId, isEqualTo: hospitalId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Doctor.fromSnapshot(doc, )).toList());
  }

  Future<List<Doctor>> getDoctorList(String hospitalId)async{
     List<Doctor> doctorList = [];
    try {
      QuerySnapshot querySnapshot = await doctorsCollection.where(ServiceUtils.doctorModel_HospitalId, isEqualTo: hospitalId).get();

      doctorList = querySnapshot.docs.map((doc) => Doctor.fromSnapshot(doc,)).toList();
    } catch (e) {
      print("Error fetching doctors: $e");
    }
    return doctorList;
  }
  


  Future<void> editDoctorProfile(String doctorId, String firstName, String lastName, String specialization, {PlatformFile? file}) async {
  try {
    AuthService authService = AuthService();
    String? profileURL;
    if (file != null) {
      profileURL = await authService.uploadFile(file);
    }
    Map<String, dynamic> updateData = {
      ServiceUtils.doctorModel_FirstName: firstName,
      ServiceUtils.doctorModel_LastName: lastName,
      ServiceUtils.doctorModel_Specialization: specialization,
    };
    if (profileURL != null) {
      updateData[ServiceUtils.doctorModel_ProfilePhoto] = profileURL;
    }
    await doctorsCollection.doc(doctorId).update(updateData);
  } catch (e) {
    print('Error editing doctor profile: $e');
    rethrow;
  }
}
Future<DateTime> getLastAppointmentDate() async {
  DateTime defaultReturnDate = DateTime.now().add(Duration(days: DateTime.now().weekday +1));
  try {
    // Query appointments collection
    QuerySnapshot<Map<String, dynamic>> snapshot = await appointmentCollection
        .orderBy(ServiceUtils.appointmentModel_AppointmentDate, descending: true) 
        .limit(1) 
        .get() as QuerySnapshot<Map<String, dynamic>> ;

    // Check if any appointments were found
    if (snapshot.docs.isNotEmpty) {
      // Get the first document (the latest appointment)
      DocumentSnapshot<Map<String, dynamic>> latestAppointment = snapshot.docs.first;
      // Extract the appointment date from the document
      DateTime lastAppointmentDate = (latestAppointment['appointmentDate'] as Timestamp).toDate();
      return lastAppointmentDate;
    } else {
      // No appointments found
      return defaultReturnDate;
    }
  } catch (e) {
    print('Error getting last appointment date: $e');
    return defaultReturnDate;
  }
}
bool isCurrentDate(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year && date.month == now.month && date.day == now.day;
}
Stream<List<Appointment>> getDoctorAllAppointmentsByDate({required DateTime date,required String doctorId,required String hospitalId}) {
  DateTime startDate = DateTime(date.year, date.month, date.day, date.hour, date.minute, date.second);
  DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
  if(isCurrentDate(date)){
    DateTime currentDay = DateTime.now();
          startDate = DateTime(date.year, date.month, date.day, currentDay.hour, currentDay.minute, currentDay.second);
   endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  
 

  return appointmentCollection
    .where(ServiceUtils.appointmentModel_AppointmentDate, isGreaterThanOrEqualTo: startDate)
    .where(ServiceUtils.appointmentModel_AppointmentDate, isLessThanOrEqualTo: endDate)
   
     .where(ServiceUtils.appointmentModel_providerId, isEqualTo: hospitalId)
      .where(ServiceUtils.appointmentModel_Doctor, isEqualTo: doctorId)
    .snapshots()
    .map((event) => List<Appointment>.from(
      event.docs.map((e) => Appointment.fromSnapshot(e as DocumentSnapshot<Map<String, dynamic>>,)).toList()));
}


Stream<List<Appointment>> getAppointmentsForDate({required DateTime date,required String doctorId,required String hospitalId}) {
  DateTime startDate = DateTime(date.year, date.month, date.day, date.hour, date.minute, date.second);
  DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
  if(isCurrentDate(date)){
    DateTime currentDay = DateTime.now();
          startDate = DateTime(date.year, date.month, date.day, currentDay.hour, currentDay.minute, currentDay.second);
   endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  
 

  return appointmentCollection
    .where(ServiceUtils.appointmentModel_AppointmentDate, isGreaterThanOrEqualTo: startDate)
    .where(ServiceUtils.appointmentModel_AppointmentDate, isLessThanOrEqualTo: endDate)
    .where(ServiceUtils.appointmentModel_isBooked, isEqualTo: false)
     .where(ServiceUtils.appointmentModel_providerId, isEqualTo: hospitalId)
      .where(ServiceUtils.appointmentModel_Doctor, isEqualTo: doctorId)
    .snapshots()
    .map((event) => List<Appointment>.from(
      event.docs.map((e) => Appointment.fromSnapshot(e as DocumentSnapshot<Map<String, dynamic>>,)).toList()));
}
}
