import 'package:flutter/material.dart';
import 'package:medibookings/screens/login_screen.dart'; // Import your login screen file
import 'package:medibookings/screens/register_screen.dart'; // Import your register screen file
import 'package:medibookings/screens/button.dart'; // Import your button file

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(fontFamily: 'TitilliumWeb'),
        ),
      ),
      body: Center( // Center the content vertically and horizontally
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 24.0, fontFamily: 'TitilliumWeb', color: Colors.blue),
              ),
              const SizedBox(height: 20.0),
              Image.asset(
                'assets/Logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 200,
                child: basicButton(
                  onPressed: () {
                    // Navigate to login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  text: 'Login',
                  height: 50.0,
                  borderRadius: 10.0,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 200,
                child: basicButton(
                  onPressed: () {
                    // Navigate to registration screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  text: 'Register',
                  height: 50.0,
                  borderRadius: 10.0,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20.0), 
            ],
          ),
        ),
      ),
    );
  }
}
