import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medibookings/model/hospital/hospital/hospital_model.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/service_utils.dart';

class HospitalService   extends DisposableService {
  HospitalModel? hospitalModel;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference hospitalsCollection =
      FirebaseFirestore.instance.collection(ServiceUtils.collection_hospital);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    hospitalModel = null;
    
  }
  Future<bool> checkHospitalExists(String hospitalName) async {
    QuerySnapshot<Object?> querySnapshot =
        await hospitalsCollection.where('name', isEqualTo: hospitalName).get();

    return querySnapshot.docs.isNotEmpty;
  }
  setHospitalModel (String hospitalId)async{
     hospitalModel = await getHospitalById(hospitalId);
     
  }
  Future<bool> checkHospitalExistsByUID(String hospitalId) async {
    try {
      final snapshot = await hospitalsCollection.doc(hospitalId).get();
   await  setHospitalModel(hospitalId);
      //ChangeNotifier();
      return snapshot.exists;
    } catch (e) {
      print('Error checking hospital existence: $e');
      rethrow;
    }
  }

  Future<void> createHospitalDocument(
      String userId, String hospitalName, String email) async {
    try {
    
      HospitalModel dummy = HospitalModel(
          documentLinks: [],
          email: email,
          id: userId,
          
          name: hospitalName,
          contactNumber: 0,
          description: "",
          hospitalImages: []
         
          );
      await _firestore
          .collection(ServiceUtils.collection_hospital)
          .doc(userId)
          .set(dummy.toMap());
    } catch (e) {
      print('Error creating hospital document: $e');
      rethrow;
    }
  }

  Future<HospitalModel> getHospitalById(String hospitalId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await hospitalsCollection.doc(hospitalId).get()  as DocumentSnapshot<Map<String, dynamic>>;
      if (snapshot.exists) {
        return HospitalModel.fromSnapshot(snapshot);
        
      } else {
        throw Exception('Hospital with ID $hospitalId not found');
      }
    } catch (e) {
      print('Error getting hospital: $e');
      rethrow;
    }
  }

  Future<void> updateDocumentList(List<String> downloadUrls)async{
    try{
      
       await hospitalsCollection.doc(firebaseAuth.currentUser!.uid).update({
          ServiceUtils.hospitalModel_DocumentLinks:downloadUrls
        });
        await getHospitalById(firebaseAuth.currentUser!.uid);
    }
    catch(e){
      rethrow;
    }}
    Future<void> updateHospitalProfile(String hospitalName,int contactNumber, GeoPoint address,HospitalModel hospitalModel)async{
    try{
        hospitalModel.name = hospitalName.toLowerCase();
        hospitalModel.contactNumber = contactNumber;
        hospitalModel.address = address;
       await hospitalsCollection.doc(firebaseAuth.currentUser!.uid).update(hospitalModel.toMap());
        await setHospitalModel(firebaseAuth.currentUser!.uid);
        notifyListeners();
       
    }
    catch(e){
       log("eroor in as$e");
      rethrow;
     
    }
  }
  
 
  

  
  Stream<List<HospitalModel>> hospitalsByPartialNameStream(String partialName) {
    return hospitalsCollection
        .where(ServiceUtils.hospitalModel_Name,
            isGreaterThanOrEqualTo: partialName.toLowerCase())
        .where(ServiceUtils.hospitalModel_Name,
            isLessThanOrEqualTo: '${partialName.toLowerCase()}\uf8ff')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return HospitalModel.fromSnapshot(
          doc as DocumentSnapshot<Map<String, dynamic>>,
          
        );
      }).toList();
    });
  }
}
