


import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';
import 'package:medibookings/model/route_model.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_detail_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/appointments/appointments_preview.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/appointments/generate_appointment_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/create_doctor_profile_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/appointments/doctor_appointment_list_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/doctor_appointment_calenndar.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/doctor_list_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/edit_doctor_profile.screen.dart';
import 'package:medibookings/presentation/screens/Hospital/home/hospital_wrapper_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/profile/hospital_profile_update.dart';
import 'package:medibookings/presentation/screens/Nurse/profile/nurse_edit_profile.dart';
import 'package:medibookings/presentation/screens/Nurse/profile/profile_screen.dart';
import 'package:medibookings/presentation/screens/Nurse/set_service/set_service_screen.dart';
import 'package:medibookings/presentation/screens/about/about_screen.dart';
import 'package:medibookings/presentation/screens/nurse/appointment/appointment_screen.dart';
import 'package:medibookings/presentation/screens/auth/account_not_verified_screen.dart';
import 'package:medibookings/presentation/screens/auth/forgot_password_screen.dart';
import 'package:medibookings/presentation/screens/auth/login_screen.dart';
import 'package:medibookings/presentation/screens/auth/register_screen.dart';
import 'package:medibookings/presentation/screens/nurse/set_charge/set_charge_screen.dart';
import 'package:medibookings/presentation/screens/nurse/reference/doctor_calendar_reference.dart';
import 'package:medibookings/presentation/screens/nurse/reference/doctor_list_for%20reference.dart';
import 'package:medibookings/presentation/screens/nurse/reference/hospital_list_byName.dart';

import 'package:medibookings/presentation/screens/splash/splash_screen.dart';
import 'package:medibookings/presentation/screens/upload_document/upload_documents_screen.dart';
import 'package:medibookings/presentation/screens/welcome/welcome_screen.dart';
import 'package:medibookings/presentation/wrapper.dart';


Map<String,WidgetBuilder> routes ={
  RouteName.splashRoute:(context)=>const SplashScreen(),
  
  RouteName.welcomeRoute:(context) => const WelcomeScreen(),
  RouteName.appWrapper:(context) => const Wrapper(),
  RouteName.loginRoute:(context) => const LoginScreen(),
  RouteName.appointmentPageRoute:(context) => const AppointmentBookingPage(),
  RouteName.registerRoute:(context) =>  const RegisterScreen(),
  
  RouteName.forgetPasswordRoute:(context) => const ForgotPasswordScreen(),
  
  RouteName.aboutRoute:(context)=>const AboutPage(),


  // RouteName.registerRoute:(context) =>  const RegisterScreen(),
  // RouteName.forgetPasswordRoute:(context) => const ForgotPasswordScreen(),
  // RouteName.uploadDocumentPageRoute:(context)=>const UploadDocumentsScreen(),
  RouteName.accountNotVerifiedScreen:(context) =>  const AccountNotVerifiedScreen(),

  // home screen
  RouteName.hospitalWrapperScreen:(context) => const HospitalWrapperScreen(),
  RouteName.hospital_doctorList_Screen:(context)=> const DoctorListScreen(),
  RouteName.hospital_createDoctorProfile:(context) => const CreateDoctorProfileScreen(),
  RouteName.hospital_editDoctorProfile:(context){
    final Doctor  doctor=  ModalRoute.of(context)!.settings.arguments as Doctor;
    return EditDoctorProfileScreen(doctor: doctor,);
  } ,
  RouteName.hospital_generate_appointment:(context) {
    Doctor doctor = ModalRoute.of(context)!.settings.arguments as Doctor;
    return  GenerateAppointmentScreen(doctor: doctor,);
  },
  RouteName.hospital_doctorAppointmentListRoute:(context){
    Doctor doctor = ModalRoute.of(context)!.settings.arguments as Doctor;
    return DoctorAppointmentListScreen(doctor: doctor,);
  },
  RouteName.hospital_profile_update:(context) => const HospitalProfileUpdatePage(),

  // apointments
  RouteName.appointmentPreviewScreen: (context) {
    final List<Appointment> appointments = ModalRoute.of(context)!.settings.arguments as List<Appointment>;
    return AppointmentPreviewScreen(appointments: appointments);
  },
// appointment
  RouteName.appointmentRoute:(context) {
    final AppointmentDetailModel  model=  ModalRoute.of(context)!.settings.arguments as AppointmentDetailModel;
    return AppointmentDetailScreeen(appointment: model.appointment,patientModel: model.patientModel,doctor: model.doctor,);

  },
 RouteName.doctorAppointmentForHospitalCalendarRoute:(context) {
  final DoctorArugument args = ModalRoute.of(context)!.settings.arguments as DoctorArugument;
  return DoctorAppointmentCalendar(
    doctodID: args.doctorId,
    hospitalID: args.hospitalId,
    isUSerCanBookAppointment: args.isUSerCanBookAppointment,
    
  );
  },

  // reference hospital
  RouteName.hospitalListByName:(context) =>  const HospitalList(),
 RouteName.doctorListForReferenceScreen:(context) {
   final String args = ModalRoute.of(context)!.settings.arguments as String;
  return  DoctorListForReferenceWidget(hospitalId: args,);
 }  ,
 RouteName.doctorCalenderInreference:(context) { 
    final DoctorArugument args = ModalRoute.of(context)!.settings.arguments as DoctorArugument;
  return DoctorAppointmentCalendarInReference(doctodID: args.doctorId, hospitalID: args.hospitalId);
},

// nurse 
RouteName.setChargeRoute:(context) =>  const SetChargeScreen(),
  RouteName.uploadDocumentPageRoute:(context){
    bool isFromNurse = ModalRoute.of(context)!.settings.arguments as bool;
    return  UploadDocumentsScreen(isFromNurse: isFromNurse,);
  },
  RouteName.profileRoute:(context)=>const ProfileScreen(),
  RouteName.setServiceRoute:(context)=> ServiceListPage(),
  RouteName.nurseEditProfileScreen:(context) {
    final NurseModel args = ModalRoute.of(context)!.settings.arguments as NurseModel;
    return EditProfileScreen(nurse: args,);
  } 

};
