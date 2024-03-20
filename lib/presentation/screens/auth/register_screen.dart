import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:provider/provider.dart';
// Import the widget for nurse registration

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Hospital'),
            Tab(text: 'Nurse'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HospitalRegistration(),
          NurseRegistration(),
        ],
      ),
    );
  }
}

class HospitalRegistration extends StatefulWidget {
  const HospitalRegistration({super.key});

  @override
  _HospitalRegistrationState createState() => _HospitalRegistrationState();
}

class _HospitalRegistrationState extends State<HospitalRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;
  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final hospitalService = Provider.of<HospitalService>(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hospital name field
                  textFormField(
                    textEditingController: _hospitalNameController,
                    decoration: defaultInputDecoration(hintText: 'Hospital Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the hospital name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // Email field
                  textFormField(
                    textEditingController: _emailController,
                    decoration: defaultInputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Add more validation if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // Password field
                  textFormField(
                    textEditingController: _passwordController,
                    decoration:
                        defaultInputDecoration(hintText: "Password").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: _toggleObscurePassword,
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Add more validation if needed
                      return null;
                    },
                  ),
                   const SizedBox(height: 16.0),
              // Confirm Password field
              textFormField(
                textEditingController: _confirmPasswordController,
                obscureText: _obscurePassword,
                decoration:
                    defaultInputDecoration(hintText: "Confirm Password").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: _toggleObscurePassword,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your confirm password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
                  const SizedBox(height: 16.0),
        
                  basicButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await authService.registerHospital(
                                _emailController.text,
                                _passwordController.text,
                                _hospitalNameController.text,
                                hospitalService);
                            Navigator.pushReplacementNamed(
                                context, RouteName.appWrapper);
                          } catch (e) {
                            // Handle registration error
                            if (e
                                .toString()
                                .contains('Hospital name already exists')) {
                              custom_snackBar(
                                  context, 'Hospital name already exists');
                            } else {
                              custom_snackBar(context, e.toString());
                            }
                          }finally{
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                      text: "Register"),
                  backLogin(context)
                ],
              ),
            ),
          ),
        ),
        if( isLoading )
        commonLoading()
      ],
    );
  }
}

class NurseRegistration extends StatefulWidget {
  const NurseRegistration({super.key});

  @override
  _NurseRegistrationState createState() => _NurseRegistrationState();
}

class _NurseRegistrationState extends State<NurseRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;
  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final nurseService = Provider.of<NurseService>(context);
    return isLoading?commonLoading(): SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First name field
              textFormField(
                textEditingController: _firstNameController,
                decoration: defaultInputDecoration(hintText: 'First Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Last name field
              textFormField(
                textEditingController: _lastNameController,
                decoration: defaultInputDecoration(hintText: 'Last Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Phone number field
              textFormField(
                textEditingController: _phoneNumberController,
                decoration: defaultInputDecoration(hintText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null ) {
                      if (int.tryParse(value)== null){
                          return 'Must be number';
                      }
                      else if (value.length > 10) {
                        return 'Contact number must be less than 10 digits long.';
                      }
                      else if (value.length < 10) {
                        return 'Contact number must be at least 10 digits long.';
                      }
                    }
                    return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Email field
              textFormField(
                textEditingController: _emailController,
                decoration: defaultInputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add more validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Password field
              textFormField(
                textEditingController: _passwordController,
                obscureText: _obscurePassword,
                decoration:
                    defaultInputDecoration(hintText: "Password").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: _toggleObscurePassword,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Add more validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Confirm Password field
              textFormField(
                textEditingController: _confirmPasswordController,
                obscureText: _obscurePassword,
                decoration:
                    defaultInputDecoration(hintText: "Confirm Password").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: _toggleObscurePassword,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your confirm password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Add document submission widget for nurse
              // Example: File picker or document upload button
              // Add submit button
              basicButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    try{
                      setState(() {
                        isLoading = true;
                      });
                      NurseModel nurseModel = NurseModel(firstName: _firstNameController.text, lastName: _lastNameController.text, phoneNumber: int.parse(_phoneNumberController.text), serviceRadius: 25);
                      await authService.registerNurse(nurse: nurseModel, email: _emailController.text, password: _passwordController.text, nurseService: nurseService);
                       Navigator.pushReplacementNamed(
                                context, RouteName.appWrapper);
                    }
                    catch(e){
                      custom_snackBar(context, "Fail to create profile");
                    }
                    finally{
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
                text: "Register",
              ),
              backLogin(context),
            ],
          ),
        ),
      ),
    );
  }
}
