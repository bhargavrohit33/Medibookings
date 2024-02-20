

import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/create_doctor_profile_screen.dart';
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

Map<String,WidgetBuilder> routes ={
  RouteName.splashRoute:(context)=>const SplashScreen(),
  RouteName.welcomeRoute:(context) => const WelcomeScreen(),
  RouteName.loginRoute:(context) => const LoginScreen(),
  RouteName.registerRoute:(context) =>  RegisterScreen(),
  RouteName.forgetPasswordRoute:(context) => const ForgotPasswordScreen(),
  RouteName.uploadDocumentPageRoute:(context)=>const UploadDocumentsScreen(),
  RouteName.accountNotVerifiedScreen:(context) =>  AccountNotVerifiedScreen(),

  // home screen
  RouteName.hospitalWrapperScreen:(context) => HospitalWrapperScreen(),
  RouteName.hospital_doctorList_Screen:(context)=> DoctorListScreen(),
  RouteName.hospital_createDoctorProfile:(context) => CreateDoctorProfileScreen(),
  RouteName.hospital_editDoctorProfile:(context) => EditDoctorProfileScreen()
};