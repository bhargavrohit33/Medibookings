
import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';


abstract class SplashScreenStateInterface {

}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> implements SplashScreenStateInterface {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, RouteName.appWrapper);
      
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Logo.png'),
          ),
        ),
      ),
    );
  }
}

