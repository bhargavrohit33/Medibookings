import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/route.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/presentation/screens/Hospital/widgets/hospital_drawer.dart';
import 'package:medibookings/presentation/screens/splash/splash_screen.dart';
//import 'package:firebase_core/firebase_core.dart'; // Import Firebase core package


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(); // Initialize Firebase app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      title: 'Hospital Appointment App',
      theme: themeData,
      routes: routes,
     
      initialRoute: RouteName.hospitalWrapperScreen, // Set initial screen to SplashScreen
    );
  }
}
