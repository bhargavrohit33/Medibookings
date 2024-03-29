import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medibookings/common/route.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/firebase_options.dart';
import 'package:medibookings/service/auth_service.dart';

import 'package:medibookings/service/hospital/doctor.service.dart';
import 'package:medibookings/service/hospital/emergency_service.dart';
import 'package:medibookings/service/hospital/hometab_service.dart';
import 'package:medibookings/service/hospital/hospital_appointment_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:medibookings/service/hospital/patient_service_hospital.dart';
import 'package:medibookings/service/hospital/reference_service.dart';
import 'package:medibookings/service/nurse/nurse_appointmet_service.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart'; 
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  print('Received background message: ${message.notification?.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
         ChangeNotifierProvider(create: (_) => HomeTabService()),
          ChangeNotifierProvider(create: (_) => HospitalService()),
           ChangeNotifierProvider(create: (contextP) => DoctorService(Provider.of<HospitalService>(contextP, listen: false))),
            ChangeNotifierProvider(create: (_) => HospitalAppointmentService()),
            ChangeNotifierProvider(create: (_) => EmergencyAppointmentService()),
            ChangeNotifierProvider(create: (_)=>PatientServiceHospital()),
            ChangeNotifierProvider(create: (_)=>ReferenceService()),
            ChangeNotifierProvider(create: (_)=>NurseService()),
             ChangeNotifierProvider(create: (_)=>NurseAppointmentService())
      ],
      child: MaterialApp(
      
        title: 'Hospital Appointment App',
        theme: themeData,
        routes: routes,
       darkTheme: ThemeData.dark(
         useMaterial3:true 
        ),
        initialRoute: RouteName.appWrapper, // Set initial screen to SplashScreen
      ),
    );
  }
}
