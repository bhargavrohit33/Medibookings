import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/service/service_utils.dart';


class PatientModel {
   final String id;
   String firstName;
   String lastName;
   int phoneNumber;
   String fcmToken;
   bool notification;

  PatientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.fcmToken,
    required this.notification,
  });

  factory PatientModel.fromSnapshot( DocumentSnapshot<Map<String, dynamic>> snapshot ) {
    return PatientModel(
      id: snapshot.id,
      firstName: capitalizeFirstLetter(snapshot.data()?[ServiceUtils.patient_firstName]??""),
      lastName: capitalizeFirstLetter(snapshot.data()?[ServiceUtils.patient_lastName]??"") ,
      phoneNumber: snapshot.data()?[ServiceUtils.patient_phoneNumber] ?? 0,
      fcmToken: snapshot.data()?[ServiceUtils.fcmToken] ?? '',
      notification: snapshot.data()?[ServiceUtils.patient_notification] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ServiceUtils.patient_firstName: firstName.toLowerCase(),
      ServiceUtils.patient_lastName: lastName.toLowerCase(),
      ServiceUtils.patient_phoneNumber: phoneNumber,
      ServiceUtils.fcmToken: fcmToken,
      ServiceUtils.patient_notification: notification,
    };
  }
}
