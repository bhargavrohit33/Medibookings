import 'package:flutter/material.dart';
import 'package:medibookings/screens/welcome_screen.dart';

// Define a public interface for SplashScreenState
abstract class SplashScreenStateInterface {
  // Define any methods or properties needed from _SplashScreenState
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> implements SplashScreenStateInterface {
  @override
  void initState() {
    super.initState();
    // Add a delay using Future.delayed to simulate a splash screen effect
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
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
