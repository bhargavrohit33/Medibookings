import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/service/service_utils.dart';

class Doctor {
  final String id;
  final String firstName;
  final String lastName;
  final String specialization;
  final String? profilePhoto;
  final String hospitalId;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialization,
    this.profilePhoto,
    required this.hospitalId,
  });

  factory Doctor.fromSnapshot(DocumentSnapshot snapshot,) {
    return Doctor(
      id: snapshot.id,
      firstName: capitalizeFirstLetter( snapshot[ServiceUtils.doctorModel_FirstName] ?? ''),
      lastName:capitalizeFirstLetter( snapshot[ServiceUtils.doctorModel_LastName] ?? ''),
      specialization: capitalizeFirstLetter(snapshot[ServiceUtils.doctorModel_Specialization] ?? ''),
      profilePhoto: snapshot[ServiceUtils.doctorModel_ProfilePhoto],
      hospitalId: snapshot[ServiceUtils.doctorModel_HospitalId] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ServiceUtils.doctorModel_FirstName: firstName.toLowerCase(),
      ServiceUtils.doctorModel_LastName: lastName.toLowerCase(),
      ServiceUtils.doctorModel_Specialization: specialization.toLowerCase(),
       ServiceUtils.doctorModel_ProfilePhoto: profilePhoto,
      ServiceUtils.doctorModel_HospitalId: hospitalId,
    };
  }
}
