import 'package:flutter/material.dart';
import 'package:medibookings/screens/splash_screen.dart';
//import 'package:firebase_core/firebase_core.dart'; // Import Firebase core package


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(); // Initialize Firebase app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital Appointment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(), // Set initial screen to SplashScreen
    );
  }
}
