import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medibookings/service/service_utils.dart';

class HospitalModel {
  final String id;
  final String name;
  final String email;
  final GeoPoint? address;
  List<String> documentLinks;
  final bool isVerified;
  final User? firebaseUser;

  HospitalModel({
    required this.id,
    required this.name,
    required this.email,
    this.address,
    required this.documentLinks,
    required this.isVerified,
    this.firebaseUser,
  });

  factory HospitalModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot, User user) {
    return HospitalModel(
      id: snapshot.id,
      name: snapshot.data()![ServiceUtils.hospitalModel_Name] ?? '',
      email: snapshot.data()![ServiceUtils.hospitalModel_Email] ?? '',
      address: snapshot.data()![ServiceUtils.hospitalModel_Address] ?? GeoPoint(0, 0),
      documentLinks: List<String>.from(snapshot.data()![ServiceUtils.hospitalModel_DocumentLinks] ?? []),
      isVerified: snapshot.data()![ServiceUtils.hospitalModel_IsVerified] ?? false,
      firebaseUser: user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ServiceUtils.hospitalModel_Name: name,
      ServiceUtils.hospitalModel_Email: email,
      ServiceUtils.hospitalModel_Address: address,
      ServiceUtils.hospitalModel_DocumentLinks: documentLinks,
      ServiceUtils.hospitalModel_IsVerified: isVerified,
    };
  }

  void setDocumentLinks(List<String> links) {
    documentLinks = links;
  }
}
