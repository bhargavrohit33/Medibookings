import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/service/service_utils.dart';

class NurseModel {
  final String firstName;
  final String lastName;
  final int phoneNumber;
  final bool isVerify;
   bool isOnline;
  final DateTime? dateOfBirth;
  final DateTime? startDateOfService;
  final String? biography;
  final GeoPoint? address;
  final List<String>? documentLinks;
  Set<String> listOfService; 
  final double perHourCharge;
  final double serviceRadius;
  final String? fcmtoken;
  final String? profileUrl;

  NurseModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.isVerify = true,
    this.isOnline = false,
    this.dateOfBirth,
    this.startDateOfService,
    this.biography,
    this.address,
    this.documentLinks,
    required this.listOfService, // Update parameter type to Set<String>
    required this.perHourCharge,
    required this.serviceRadius,
    this.fcmtoken,
    this.profileUrl,
  });

  static NurseModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return NurseModel(
      firstName: data?[ServiceUtils.nurse_firstName] ?? '',
      lastName: data?[ServiceUtils.nurse_lastName] ?? '',
      phoneNumber: data?[ServiceUtils.nurse_phoneNumber] ?? 0,
      isVerify: data?[ServiceUtils.nurse_isVerify] ?? false,
      isOnline: data?[ServiceUtils.nurse_isOnline] ?? false,
      dateOfBirth: data?[ServiceUtils.nurse_dateOfBirth]?.toDate(),
      startDateOfService: data?[ServiceUtils.nurse_startDateOfService]?.toDate(),
      biography: data?[ServiceUtils.nurse_biography] ?? "",
      address: data?[ServiceUtils.nurse_address] ?? const GeoPoint(0, 0),
      documentLinks: List<String>.from(data?[ServiceUtils.nurse_documentLinks] ?? []),
      listOfService: Set<String>.from(data?[ServiceUtils.nurse_listOfService] ?? []), // Convert to Set
      perHourCharge: data?[ServiceUtils.nurse_perHourCharge]?.toDouble() ?? 0.0,
      serviceRadius: data?[ServiceUtils.nurse_serviceRadius]?.toDouble() ?? 0.0,
      fcmtoken: data?[ServiceUtils.fcmToken] ?? "",
      profileUrl: data?[ServiceUtils.nurse_profileUrl] ?? "",
    );
  }

  setListOfService(Set<String> listOfService) { // Change parameter type to Set<String>
    this.listOfService = listOfService;
  }

  Map<String, dynamic> toMap() {
    return {
      ServiceUtils.nurse_firstName: firstName.toLowerCase(),
      ServiceUtils.nurse_lastName: lastName.toLowerCase(),
      ServiceUtils.nurse_phoneNumber: phoneNumber,
      ServiceUtils.nurse_isVerify: isVerify,
      ServiceUtils.nurse_isOnline: isOnline,
      ServiceUtils.nurse_dateOfBirth: dateOfBirth,
      ServiceUtils.nurse_startDateOfService: startDateOfService,
      ServiceUtils.nurse_biography: biography,
      ServiceUtils.nurse_address: address,
      ServiceUtils.nurse_documentLinks: documentLinks,
      ServiceUtils.nurse_listOfService: listOfService.toList(), // Convert Set to List
      ServiceUtils.nurse_perHourCharge: perHourCharge,
      ServiceUtils.nurse_serviceRadius: serviceRadius,
      ServiceUtils.fcmToken: fcmtoken,
      ServiceUtils.nurse_profileUrl: profileUrl,
    };
  }
}
