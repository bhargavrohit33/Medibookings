import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/presentation/screens/auth/register_screen.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/screens/welcome/welcome_screen.dart';
import 'package:medibookings/presentation/screens/auth/forgot_password_screen.dart';
import 'package:medibookings/presentation/widget/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the form

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 24.0, color: Colors.blue),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Please Login to your Account',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(
                  height: 20,
                ),
                textFormField(
                  textEditingController: TextEditingController(),
                  decoration: defaultInputDecoration(hintText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  
                ),
                const SizedBox(height: 16.0),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    textFormField(
                      textEditingController: TextEditingController(),
                      obscureText: true,
                      decoration: defaultInputDecoration(hintText: "Password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                     
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, RouteName.forgetPasswordRoute);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                basicButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // form logic
                      Navigator.pushReplacementNamed(context, RouteName.loginRoute);
                    }
                  },
                  text: 'Login',
                  height: 48,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account, "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, RouteName.registerRoute);
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
