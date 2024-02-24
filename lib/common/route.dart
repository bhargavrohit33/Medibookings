

import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/presentation/screens/appointment/appointment_screen.dart';
import 'package:medibookings/presentation/screens/auth/forgot_password_screen.dart';
import 'package:medibookings/presentation/screens/auth/login_screen.dart';
import 'package:medibookings/presentation/screens/auth/register_screen.dart';
import 'package:medibookings/presentation/screens/home/home_screen.dart';
import 'package:medibookings/presentation/screens/set_charge/set_charge_screen.dart';
import 'package:medibookings/presentation/screens/splash/splash_screen.dart';
import 'package:medibookings/presentation/screens/upload_document/upload_documents_screen.dart';
import 'package:medibookings/presentation/screens/welcome/welcome_screen.dart';

Map<String,WidgetBuilder> routes ={
  RouteName.splashRoute:(context)=>const SplashScreen(),
  RouteName.homePageRoute:(context)=>const HomePage(),
  RouteName.welcomeRoute:(context) => const WelcomeScreen(),
  RouteName.loginRoute:(context) => const LoginScreen(),
  RouteName.appointmentPageRoute:(context) => const AppointmentScreen(),
  RouteName.registerRoute:(context) =>  RegisterScreen(),
  RouteName.setChargeRoute:(context) =>  const SetChargeScreen(),
  RouteName.forgetPasswordRoute:(context) => const ForgotPasswordScreen(),
  RouteName.uploadDocumentPageRoute:(context)=>const UploadDocumentsScreen()
};