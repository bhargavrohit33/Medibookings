

import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
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
  RouteName.uploadDocumentPageRoute:(context)=>const UploadDocumentsScreen()
};