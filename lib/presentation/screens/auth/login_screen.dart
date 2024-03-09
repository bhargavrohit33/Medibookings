import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the form
   bool _obscurePassword = true;
  bool isLoading = false;
  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

 TextEditingController emailController =TextEditingController();
 TextEditingController passwordController =TextEditingController();

  @override
  Widget build(BuildContext context) {
   final provider = Provider.of<AuthService>(context );
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      textEditingController: emailController,
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
                          textEditingController: passwordController,
                           obscureText: _obscurePassword,
                          decoration:  defaultInputDecoration(hintText: "Password").copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: _toggleObscurePassword,
                          ),
                        ),
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
                      onPressed: ()async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          try{
                            setState(() {
                              isLoading = true;
                            });
                             final result = await provider.login(emailController.text, passwordController.text);
                        if ( result == true){
                          
                          Navigator.pushReplacementNamed(context, RouteName.appWrapper);
                        }else{
                          custom_snackBar(context,"Fail");
                        }
                          }catch(e){
                            custom_snackBar(context, e.toString());
                          }finally{
                            setState(() {
                              isLoading = false;
                            });
                          }
                       
                          
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
                          child:  Text(
                            'Register',
                            style: TextStyle(color: blueColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if(isLoading)
          commonLoading()
        ],
      ),
    );
  }
}
