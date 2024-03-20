import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Forgot Password',
                style: TextStyle(fontSize: 24.0, fontFamily: 'TitilliumWeb'),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Please enter the email address you would like your password reset information sent to',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20.0),
              textFormField(
                textEditingController: emailController,
                decoration: defaultInputDecoration(hintText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                          r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              basicButton(
                onPressed: () {
                  try {
                    _authProvider.forgetPassowrd(emailController.text);

                    custom_snackBar(context, 'Password reset email sent');
                  } catch (e) {
                    print('Error sending password reset email: $e');
                    custom_snackBar(
                        context, 'Failed to send password reset email');
                  }
                  Navigator.pushReplacementNamed(
                      context, RouteName.welcomeRoute);
                },
                text: 'Reset Password',
                width: double.infinity,
                height: 50.0,
                borderRadius: 10.0,
                color: primaryColor,
              ),
              const SizedBox(height: 20.0),
              backLogin(context)
            ],
          ),
        ),
      ),
    );
  }
}
