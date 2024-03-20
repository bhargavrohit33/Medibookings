import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/service_utils.dart';

class  NurseService extends DisposableService{
  final CollectionReference nurseCollection = FirebaseFirestore.instance.collection(ServiceUtils.collection_nurse);
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  NurseModel? nurseModel ;
  Future<void> createNurseProfile ({required NurseModel nurseModel,required  User user})async{
    try{
       await nurseCollection.doc(user.uid).set(
            nurseModel.toMap(),
          );
    }catch(e){
      rethrow;
    }
  }
  Future<void> updateDocumentList(List<String> downloadUrls)async{
    try{
      
       await nurseCollection.doc(firebaseAuth.currentUser!.uid).update({
          ServiceUtils.nurse_documentLinks:downloadUrls
        });
       
    }
    catch(e){
      rethrow;
    }}
Future<void> updateNurseProfile(NurseModel nurseModel)async{
    try{
      
       await nurseCollection.doc(firebaseAuth.currentUser!.uid).update(nurseModel.toMap());
       
    }
    catch(e){
      rethrow;
    }}


  Stream<NurseModel> get getNurseProfile{
    return nurseCollection.doc(firebaseAuth.currentUser!.uid).snapshots().map(getNurseProfileSett);
  }

  NurseModel getNurseProfileSett(DocumentSnapshot snapshot){
    nurseModel = NurseModel.fromSnapshot(snapshot as DocumentSnapshot<Map<String, dynamic>> );
    return nurseModel!;
  }
  Future<void> updateFcmToken()async{
    _firebaseMessaging.requestPermission();
   String? fcm = await _firebaseMessaging.getToken();
    await  nurseCollection.doc(firebaseAuth.currentUser!.uid).update({
      ServiceUtils.fcmToken:fcm
    });
  }
}