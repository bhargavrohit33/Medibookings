import 'package:flutter/material.dart';
import 'package:medibookings/screens/welcome_screen.dart';
import 'package:medibookings/screens/forgot_password_screen.dart'; // Import your home screen file

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the form

  String _email = '';
  String _password = '';
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Login',
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[200], // Gray filled background
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none, // Remove border line
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none, // Remove border line
                  ),
                ),
                style: TextStyle(color: Colors.grey[800]), // Text color
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  // You can use a regex for more precise email validation
                  if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[200], // Gray filled background
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none, // Remove border line
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none, // Remove border line
                  ),
                ),
                style: TextStyle(color: Colors.grey[800]), // Text color
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Perform login logic
                    // For now, let's just navigate to the home screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    );
                  }
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.blue.withOpacity(0.2); // Hover color
                      } else {
                        return Colors.transparent; // Default color
                      }
                    },
                  ),
                  elevation: MaterialStateProperty.resolveWith<double>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return 10; // Shadow elevation when hovered
                      } else {
                        return 0; // No shadow by default
                      }
                    },
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
              const SizedBox(height: 8.0), // Add some space between buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate to Forgot Password Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                  );
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.blueAccent.withOpacity(0.2); // Hover color
                      } else {
                        return Colors.transparent; // Default color
                      }
                    },
                  ),
                  elevation: MaterialStateProperty.resolveWith<double>(
                        (states) {
                      if (states.contains(MaterialState.hovered)) {
                        return 10; // Shadow elevation when hovered
                      } else {
                        return 0; // No shadow by default
                      }
                    },
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), // Background color
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                ),
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
