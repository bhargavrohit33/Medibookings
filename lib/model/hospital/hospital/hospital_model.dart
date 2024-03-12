import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/service/service_utils.dart';

class HospitalModel {
  final String id;
  final String name;
  final String email;
  final GeoPoint? address;
  final int contactNumber;
  List<String> documentLinks;
  final bool isVerified;
  final User? firebaseUser;
  String description;
  List<String> hospitalImages;

  HospitalModel({
    required this.id,
    required this.name,
    required this.email,
    this.address,
    required this.contactNumber,
    required this.documentLinks,
    required this.isVerified,
    this.firebaseUser,
    required this.description,
    required this.hospitalImages,
  });

  factory HospitalModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot, User user) {
    return HospitalModel(
      id: snapshot.id,
      name: capitalizeFirstLetter(snapshot.data()![ServiceUtils.hospitalModel_Name] ?? ''),
      email: capitalizeFirstLetter(snapshot.data()![ServiceUtils.hospitalModel_Email] ?? ''),
      address: snapshot.data()![ServiceUtils.hospitalModel_Address] ?? GeoPoint(0, 0),
      contactNumber: snapshot.data()![ServiceUtils.hospitalModel_ContactNumber] ,
      documentLinks: List<String>.from(snapshot.data()![ServiceUtils.hospitalModel_DocumentLinks] ?? []),
      isVerified: snapshot.data()![ServiceUtils.hospitalModel_IsVerified] ?? false,
      firebaseUser: user,
      description: snapshot.data()![ServiceUtils.hospitalModel_Description] ?? '',
      hospitalImages: List<String>.from(snapshot.data()![ServiceUtils.hospitalModel_HospitalImages] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ServiceUtils.hospitalModel_Name: name.toLowerCase(),
      ServiceUtils.hospitalModel_Email: email.toLowerCase(),
      ServiceUtils.hospitalModel_Address: address,
      ServiceUtils.hospitalModel_ContactNumber: contactNumber,
      ServiceUtils.hospitalModel_DocumentLinks: documentLinks,
      ServiceUtils.hospitalModel_IsVerified: isVerified,
      ServiceUtils.hospitalModel_Description: description,
      ServiceUtils.hospitalModel_HospitalImages: hospitalImages,
    };
  }

  void setDocumentLinks(List<String> links) {
    documentLinks = links;
  }
}
