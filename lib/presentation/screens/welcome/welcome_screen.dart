import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/presentation/screens/auth/login_screen.dart';
import 'package:medibookings/presentation/screens/auth/register_screen.dart';
import 'package:medibookings/presentation/screens/widget/button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(fontFamily: 'TitilliumWeb'),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Nurse.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
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
                        Navigator.pushReplacementNamed(context, RouteName.loginRoute);
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
                        Navigator.pushReplacementNamed(context, RouteName.registerRoute);
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
        ],
      ),
    );
  }
}
