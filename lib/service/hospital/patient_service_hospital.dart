import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/model/hospital/patient/patient_model.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/service_utils.dart';

class PatientServiceHospital extends DisposableService{
  Future<PatientModel?> getPatientById(String patientId) async {
    final CollectionReference collectionReference = FirebaseFirestore.instance.collection(ServiceUtils.collection_patient);
    try {
      DocumentSnapshot snapshot = await collectionReference
          .doc(patientId)
          .get();

      if (snapshot.exists) {
        return PatientModel.fromSnapshot(snapshot as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching patient data by ID: $error');
      return null;
    }
  }
}