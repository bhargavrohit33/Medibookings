import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:medibookings/service/service_utils.dart';

class DoctorService extends DisposableService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection(ServiceUtils.collection_doctor);
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
  Future<void> setDoctor(Doctor _doctor)async{
    doctor =   _doctor;
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
      throw e;
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
      throw e;
    }
  }
  Stream<Doctor>  getDoctorByIdStream(String doctorId){
    return doctorsCollection.doc(doctorId).snapshots().map((event) => Doctor.fromSnapshot(event));
  }

  Stream<List<Doctor>> getDoctorsByHospitalIdStream() {
    
    return doctorsCollection
        .where(ServiceUtils.doctorModel_HospitalId, isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Doctor.fromSnapshot(doc, )).toList());
  }

  Future<List<Doctor>> getDoctorList(String hospitalId)async{
     List<Doctor> _doctorList = [];
    try {
      QuerySnapshot querySnapshot = await doctorsCollection.where(ServiceUtils.doctorModel_HospitalId, isEqualTo: hospitalId).get();

      _doctorList = querySnapshot.docs.map((doc) => Doctor.fromSnapshot(doc,)).toList();
    } catch (e) {
      print("Error fetching doctors: $e");
    }
    return _doctorList;
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
    throw e;
  }
}
}
