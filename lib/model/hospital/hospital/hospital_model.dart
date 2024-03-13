import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/service/service_utils.dart';

class HospitalModel {
  final String id;
  String _name;
  final String email;
  GeoPoint? _address;
  int _contactNumber;
  List<String> documentLinks;
  final bool isVerified;
  final User? firebaseUser;
  String description;
  List<String> hospitalImages;

  HospitalModel({
    required this.id,
    required String name,
    required this.email,
    GeoPoint? address,
    required int contactNumber,
    required this.documentLinks,
    required this.isVerified,
    this.firebaseUser,
    required this.description,
    required this.hospitalImages,
  })   : _name = name,
        _address = address,
        _contactNumber = contactNumber;

  factory HospitalModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot, User user) {
    return HospitalModel(
      id: snapshot.id,
      name: capitalizeFirstLetter(
              snapshot.data()![ServiceUtils.hospitalModel_Name] ?? '') ??
          '',
      email: capitalizeFirstLetter(
              snapshot.data()![ServiceUtils.hospitalModel_Email] ?? '') ??
          '',
      address: snapshot.data()![ServiceUtils.hospitalModel_Address] ??
          GeoPoint(0, 0),
      contactNumber: snapshot.data()![
              ServiceUtils.hospitalModel_ContactNumber] ??
          0,
      documentLinks: List<String>.from(snapshot.data()![
              ServiceUtils.hospitalModel_DocumentLinks] ??
          []),
      isVerified:
          snapshot.data()![ServiceUtils.hospitalModel_IsVerified] ?? false,
      firebaseUser: user,
      description: snapshot.data()![
              ServiceUtils.hospitalModel_Description] ??
          '',
      hospitalImages: List<String>.from(snapshot.data()![
              ServiceUtils.hospitalModel_HospitalImages] ??
          []),
    );
  }
 String get name => _name;
  GeoPoint? get address => _address;
  int get contactNumber => _contactNumber;
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

  // Setter method for 'name'
  set name(String newName) {
    _name = newName;
  }

  // Setter method for 'contactNumber'
  set contactNumber(int newContactNumber) {
    _contactNumber = newContactNumber;
  }

  // Setter method for 'address'
  set address(GeoPoint? newAddress) {
    _address = newAddress;
  }
}
