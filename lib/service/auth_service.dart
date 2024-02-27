import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:medibookings/service/disposable_service.dart';

class AuthService extends DisposableService {
  User? user;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Stream to listen to authentication state changes
  Stream<User?> get authStream {
    
    return firebaseAuth.authStateChanges();
  }

  // Method to register a new user
  Future<void> register(String email, String password,String hospitalName,HospitalService hospitalService) async {
    try {
      bool hospitalExists = await hospitalService.checkHospitalExists(hospitalName);
      if (hospitalExists) {
        throw Exception('Hospital name already exists');
      }
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      
      await hospitalService.createHospitalDocument(userCredential.user!.uid, hospitalName,email);

    
    } catch (e) {
      log('Error registering hospital: $e');
     if (e is FirebaseAuthException) {
      log('Firebase Error: ${e.message}');
      throw Exception(e.message);
    } else {
      log('Error registering hospital: $e');
      throw e;
    }
    }
  }

   Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      notifyListeners();
      return true;
    } catch (e ) {
     
       if (e is FirebaseAuthException) {
      log('Firebase Error: ${e.message}');
      throw Exception(e.message);
    } 
      
      throw e;
    }
  }

  
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      user = null;
      notifyListeners();
    } catch (e) {
      
      print('Error logging out user: $e');
      throw e;
    }
  }

  Future<void> forgetPassowrd(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      notifyListeners();
    } catch (e) {
      
      print('Error logging out user: $e');
      throw e;
    }
  }
Future<List<String>> documentsupload(List<PlatformFile> selectedFiles,HospitalService hospitalService) async {
  final List<String> downloadUrls = await uploadFiles(selectedFiles);
  await hospitalService.updateDocumentList(downloadUrls);
  return downloadUrls;
}
Future<List<String>> uploadFiles(List<PlatformFile> selectedFiles)async{
  final List<String> downloadUrls = [];
  for (final PlatformFile file in selectedFiles) {
    

    final downloadUrl = await uploadFile(file);
    downloadUrls.add(downloadUrl);
  }
  return downloadUrls;
}
Future<String> uploadFile(PlatformFile file)async{
  final firebaseStorage = FirebaseStorage.instance;
    final reference = firebaseStorage.ref().child(firebaseAuth.currentUser!.uid).child(file.name);
    final task = reference.putFile(File(file.path!));

    final snapshot = await task.whenComplete(() => null);

   return await snapshot.ref.getDownloadURL();
}
  @override
  void dispose() {
    // TODO: implement dispose
  }



  
}
