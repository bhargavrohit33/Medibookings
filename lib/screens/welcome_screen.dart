import 'package:flutter/material.dart';
import 'package:medibookings/screens/login_screen.dart'; // Import your login screen file
import 'package:medibookings/screens/register_screen.dart'; // Import your register screen file

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome',
          style: TextStyle(fontFamily: 'TitilliumWeb'), // Using Titillium Web font
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 24.0, fontFamily: 'TitilliumWeb'), // Using Titillium Web font
            ),
            const SizedBox(height: 20.0),
            Image.asset(
              'assets/Logo.png',
              width: 150, // Adjust the width of the logo as needed
              height: 150, // Adjust the height of the logo as needed
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to login screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Background color of button
                onPrimary: Colors.white, // Text color of button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontFamily: 'TitilliumWeb', color: Colors.white), // Using Titillium Web font and setting text color to white
              ),
            ),
            const SizedBox(
              height:20,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to registration screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent, // Background color of button
                onPrimary: Colors.white, // Text color of button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
              ),
              child: const Text(
                'Register',
                style: TextStyle(fontFamily: 'TitilliumWeb', color: Colors.white), // Using Titillium Web font and setting text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
