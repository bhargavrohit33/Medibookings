

import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_detail_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/department/appointments_preview.dart';
import 'package:medibookings/presentation/screens/Hospital/department/generate_appointment_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/create_doctor_profile_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/doctor_appointment_list_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/doctor_list_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/edit_doctor_profile.screen.dart';
import 'package:medibookings/presentation/screens/Hospital/home/hospital_wrapper_screen.dart';
import 'package:medibookings/presentation/screens/auth/account_not_verified_screen.dart';
import 'package:medibookings/presentation/screens/auth/forgot_password_screen.dart';
import 'package:medibookings/presentation/screens/auth/login_screen.dart';
import 'package:medibookings/presentation/screens/auth/register_screen.dart';
import 'package:medibookings/presentation/screens/splash/splash_screen.dart';
import 'package:medibookings/presentation/screens/upload_document/upload_documents_screen.dart';
import 'package:medibookings/presentation/screens/welcome/welcome_screen.dart';
import 'package:medibookings/presentation/wrapper.dart';

Map<String,WidgetBuilder> routes ={
  RouteName.splashRoute:(context)=>const SplashScreen(),
  RouteName.welcomeRoute:(context) => const WelcomeScreen(),
  RouteName.appWrapper:(context) => const Wrapper(),
  RouteName.loginRoute:(context) => const LoginScreen(),
  RouteName.registerRoute:(context) =>  const RegisterScreen(),
  RouteName.forgetPasswordRoute:(context) => const ForgotPasswordScreen(),
  RouteName.uploadDocumentPageRoute:(context)=>const UploadDocumentsScreen(),
  RouteName.accountNotVerifiedScreen:(context) =>  const AccountNotVerifiedScreen(),

  // home screen
  RouteName.hospitalWrapperScreen:(context) => const HospitalWrapperScreen(),
  RouteName.hospital_doctorList_Screen:(context)=> const DoctorListScreen(),
  RouteName.hospital_createDoctorProfile:(context) => const CreateDoctorProfileScreen(),
  RouteName.hospital_editDoctorProfile:(context) => const EditDoctorProfileScreen(),
  RouteName.hospital_generate_appointment:(context) => const GenerateAppointmentScreen(),
  RouteName.hospital_doctorAppointmentListRoute:(context) => const DoctorAppointmentListScreen(),
  
  
  // apointments
  RouteName.appointmentPreviewScreen: (context) {
    final List<DateTime> appointments = ModalRoute.of(context)!.settings.arguments as List<DateTime>;
    return AppointmentPreviewScreen(appointments: appointments);
  },
// appointment
  RouteName.appointmentRoute:(context) {
    final Appointment  appointment=  ModalRoute.of(context)!.settings.arguments as Appointment;
    return AppointmentDetailScreeen(appointment);

  },

 
};