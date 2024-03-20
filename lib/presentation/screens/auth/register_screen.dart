import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/screens/widget/button.dart';
    // Import the widget for nurse registration

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
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
        children: [
          HospitalRegistration(), // Widget for hospital registration
          NurseRegistration(),    // Widget for nurse registration
        ],
      ),
    );
  }
}




class HospitalRegistration extends StatefulWidget {
  @override
  _HospitalRegistrationState createState() => _HospitalRegistrationState();
}

class _HospitalRegistrationState extends State<HospitalRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                decoration: defaultInputDecoration(hintText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Add more validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              

              basicButton(onPressed: (){if (_formKey.currentState!.validate()) {
                    // Submit logic
                    // Example: Submit hospital registration data
                  }}, text: "Register"),
backLogin(context)
                  
              
            ],
          ),
        ),
      ),
    );
  }
}
class NurseRegistration extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Add more validation if needed
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
                decoration: defaultInputDecoration(hintText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Add more validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Add document submission widget for nurse
              // Example: File picker or document upload button
              // Add submit button
              basicButton(onPressed: (){
                Navigator.pushNamed(context, RouteName.uploadDocumentPageRoute);
                if (_formKey.currentState!.validate()) {
                    
                  }},text: "Register"),

              backLogin(context)
            ],
          ),
        ),
      ),
    );
  }
}


